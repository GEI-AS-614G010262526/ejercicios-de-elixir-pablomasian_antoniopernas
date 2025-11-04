defmodule Servidor do
  @moduledoc """
  Servidor (master) que crea un pool de trabajadores y coordina la
  ejecución de lotes (batches) de funciones.

  Características implementadas:
  - Se crea un pool fijo de `n` trabajadores en `start/1`.
  - Si un lote tiene más trabajos que el tamaño del pool, devuelve
    `{:error, :lote_demasiado_grande}`.
  - Los lotes con tamaño <= pool se encolan si no hay suficientes
    trabajadores ociosos; se procesan cuando haya trabajadores libres.
  - `run_batch/2` es una llamada síncrona: envía el lote y espera la
    lista de resultados en el mismo orden.
  """

  @spec start(integer()) :: {:ok, pid()}
  def start(n) when is_integer(n) and n > 0 do
    pid = spawn_link(fn -> init(n) end)
    {:ok, pid}
  end

  @spec run_batch(pid(), list()) :: list() | {:error, any()}
  def run_batch(master, jobs) when is_pid(master) and is_list(jobs) do
    send(master, {:trabajos, self(), jobs})

    receive do
      {:ok_resultados, resultados} -> resultados
      {:error, reason} -> {:error, reason}
    end
  end

  @spec stop(pid()) :: :ok
  def stop(master) when is_pid(master) do
    send(master, {:stop, self()})

    receive do
      :ok -> :ok
    end
  end

  # Server internals
  defp init(n) do
    workers = for _ <- 1..n, do: Trabajador.start_link()

    state = %{
      pool_size: n,
      workers: workers,
      idle: MapSet.new(workers),
      # batch_ref => %{from:, pending:, results: %{} , size: integer}
      in_progress: %{},
      queue: :queue.new()
    }

    loop(state)
  end

  defp loop(state) do
    receive do
      {:trabajos, from, trabajos} when is_list(trabajos) ->
        batch_size = length(trabajos)

        if batch_size > state.pool_size do
          send(from, {:error, :lote_demasiado_grande})
          loop(state)
        else
          batch_ref = make_ref()

          batch = %{
            from: from,
            trabajos: trabajos,
            pending: batch_size,
            results: %{},
            size: batch_size
          }

          new_queue = :queue.in({batch_ref, batch}, state.queue)
          new_state = %{state | queue: new_queue}

          # intentar arrancar batches encolados
          new_state = try_start_batches(new_state)

          loop(new_state)
        end

      {:resultado, batch_ref, index, result, worker_pid} ->
        # marcar worker como ocioso
        idle = MapSet.put(state.idle, worker_pid)

        case Map.fetch(state.in_progress, batch_ref) do
          :error ->
            # resultado desconocido (podría ser tardío), ignorar
            loop(%{state | idle: idle})

          {:ok, batch} ->
            # unwrap result tuple from Trabajador: {:ok, v} -> v, errors kept as-is
            value =
              case result do
                {:ok, v} -> v
                other -> other
              end

            results = Map.put(batch.results, index, value)
            pending = batch.pending - 1
            batch2 = %{batch | results: results, pending: pending}

            in_progress =
              if pending == 0 do
                # enviar resultados ordenados
                ordered = for i <- 1..batch2.size, do: Map.get(results, i)
                send(batch.from, {:ok_resultados, ordered})
                Map.delete(state.in_progress, batch_ref)
              else
                Map.put(state.in_progress, batch_ref, batch2)
              end

            new_state = %{state | idle: idle, in_progress: in_progress}
            # ahora intentar arrancar batches encolados
            new_state = try_start_batches(new_state)
            loop(new_state)
        end

      {:stop, from} ->
        # parar todos los trabajadores
        Enum.each(state.workers, fn pid -> send(pid, :stop) end)
        send(from, :ok)
        :ok

      _other ->
        loop(state)
    end
  end

  # Intentar arrancar batches desde la cola siempre que haya suficientes
  # trabajadores ociosos para procesar el lote de la cabeza.
  defp try_start_batches(state) do
    case :queue.out(state.queue) do
      {:empty, _} ->
        state

      {{:value, {batch_ref, batch}}, rest} ->
        idle_count = MapSet.size(state.idle)

        if batch.size <= idle_count do
          # asignar trabajos a trabajadores ociosos
          {workers_to_use, new_idle} = take_n_from_set(state.idle, batch.size)

          Enum.with_index(batch.trabajos, 1)
          |> Enum.zip(workers_to_use)
          |> Enum.each(fn {{func, idx}, worker_pid} ->
            send(worker_pid, {:trabajo, self(), func, batch_ref, idx})
          end)

          in_progress = Map.put(state.in_progress, batch_ref, batch)
          new_state = %{state | idle: new_idle, in_progress: in_progress, queue: rest}

          # intentar arrancar siguientes batches recursivamente
          try_start_batches(new_state)
        else
          # no hay suficientes ociosos: dejar en cola
          state
        end
    end
  end

  defp take_n_from_set(set, n) do
    {take, rest} = MapSet.to_list(set) |> Enum.split(n)
    {take, MapSet.new(rest)}
  end
end
