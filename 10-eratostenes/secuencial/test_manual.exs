#!/usr/bin/env elixir

# Script para probar la implementación secuencial del Cribado de Eratóstenes

# Cargar el módulo
Code.load_file("eratostenes.ex")

IO.puts("=== Pruebas del Cribado de Eratóstenes (Versión Secuencial) ===\n")

# Casos de prueba
test_cases = [
  {10, "Primos hasta 10"},
  {20, "Primos hasta 20"},
  {30, "Primos hasta 30"},
  {50, "Primos hasta 50"},
  {100, "Primos hasta 100"}
]

Enum.each(test_cases, fn {n, descripcion} ->
  IO.puts("#{descripcion}:")
  
  # Medir tiempo de ejecución
  {time_microsec, primos} = :timer.tc(fn -> Eratostenes.primos(n) end)
  time_ms = time_microsec / 1000
  
  IO.puts("  Resultado: #{inspect(primos)}")
  IO.puts("  Cantidad de primos: #{length(primos)}")
  IO.puts("  Tiempo: #{Float.round(time_ms, 2)} ms\n")
end)

IO.puts("Para probar interactivamente, inicia IEx y carga el archivo:")
IO.puts("  $ iex")
IO.puts("  iex> c \"eratostenes.ex\"")
IO.puts("  iex> Eratostenes.primos(30)")