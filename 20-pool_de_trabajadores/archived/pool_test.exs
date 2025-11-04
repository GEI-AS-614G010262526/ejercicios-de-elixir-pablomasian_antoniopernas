Code.require_file("trabajador.ex", __DIR__)
Code.require_file("servidor.ex", __DIR__)

ExUnit.start()

defmodule PoolTest do
  use ExUnit.Case

  test "run_batch returns results in order" do
    {:ok, server} = Servidor.start(3)

    jobs = [fn -> 1 end, fn -> 2 end, fn -> 3 end]

    assert Servidor.run_batch(server, jobs) == [1, 2, 3]

    Servidor.stop(server)
  end

  test "lote demasiado grande devuelve error" do
    {:ok, server} = Servidor.start(2)

    jobs = [fn -> 1 end, fn -> 2 end, fn -> 3 end]

    assert Servidor.run_batch(server, jobs) == {:error, :lote_demasiado_grande}

    Servidor.stop(server)
  end

  test "batches se encolan y se procesan cuando hay recursos" do
    {:ok, server} = Servidor.start(2)

    long_job = fn ->
      Process.sleep(100)
      :ok
    end

    short_job = fn -> :now end

    # lanzar primer cliente en proceso separado para que se bloquee
    caller1 = self()

    _pid1 =
      spawn(fn -> send(caller1, {:r1, Servidor.run_batch(server, [long_job, long_job])}) end)

    # dar tiempo para que el primer lote se asigne
    Process.sleep(10)

    # segundo cliente envía un lote que debe encolarse (size <= pool) y esperar
    caller2 = self()
    _pid2 = spawn(fn -> send(caller2, {:r2, Servidor.run_batch(server, [short_job])}) end)

    # recibir resultados
    assert_receive {:r1, [:ok, :ok]}, 500
    assert_receive {:r2, [:now]}, 500

    Servidor.stop(server)
  end
end
