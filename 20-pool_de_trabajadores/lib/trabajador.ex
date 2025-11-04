defmodule Trabajador do
  @moduledoc """
  Trabajador simple: espera mensajes {:trabajo, from, func, batch_ref, index}
  ejecuta `func.()` y envía {:resultado, batch_ref, index, result, self()} a `from`.
  También acepta `:stop` para terminar.
  """

  def start_link() do
    spawn_link(fn -> loop() end)
  end

  defp loop() do
    receive do
      {:trabajo, from, func, batch_ref, index} ->
        # Ejecutar trabajo (capturamos también excepciones para no matar al master)
        result =
          try do
            {:ok, func.()}
          rescue
            e -> {:error, {:exception, e}}
          catch
            kind, reason -> {:error, {kind, reason}}
          end

        send(from, {:resultado, batch_ref, index, result, self()})
        loop()

      :stop ->
        :ok

      _other ->
        loop()
    end
  end
end
