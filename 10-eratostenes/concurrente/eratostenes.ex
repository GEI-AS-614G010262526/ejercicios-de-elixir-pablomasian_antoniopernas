defmodule Eratostenes do
  @moduledoc """
  Implementación concurrente del Cribado de Eratóstenes.
  
  Esta versión utiliza procesos para verificar concurrentemente si cada número
  es divisible por los primos ya encontrados.
  """

  def primos(n) when n < 2, do: []
  def primos(2), do: [2]

  def primos(n) do
    # Inicializar con el 2
    primos_encontrados = [2]
    
    # Verificar números del 3 al n
    primos_finales = Enum.reduce(3..n, primos_encontrados, fn numero, primos_actuales ->
      if es_primo_concurrente?(numero, primos_actuales) do
        primos_actuales ++ [numero]
      else
        primos_actuales
      end
    end)
    
    primos_finales
  end

  # Verifica si un número es primo usando procesos concurrentes
  defp es_primo_concurrente?(numero, primos_conocidos) do
    parent = self()
    
    # Solo necesitamos verificar primos hasta la raíz cuadrada del número
    limite = :math.sqrt(numero) |> Float.ceil() |> trunc()
    primos_relevantes = Enum.filter(primos_conocidos, fn p -> p <= limite end)
    
    if primos_relevantes == [] do
      # No hay primos menores o iguales a la raíz cuadrada, es primo
      true
    else
      # Crear un proceso verificador para cada primo relevante
      _tasks = Enum.map(primos_relevantes, fn primo ->
        spawn(fn -> 
          # Si es divisible por el primo, enviar false
          # Si no es divisible, enviar true
          es_coprime = rem(numero, primo) != 0
          send(parent, {:verificacion, primo, es_coprime})
        end)
      end)
      
      # Recoger resultados: debe ser coprime con TODOS los primos
      recoger_resultados(length(primos_relevantes), true)
    end
  end

  # Recoge los resultados de todos los procesos verificadores
  defp recoger_resultados(0, acumulador), do: acumulador
  
  defp recoger_resultados(pendientes, acumulador) do
    receive do
      {:verificacion, _primo, false} ->
        # Es divisible por algún primo, definitivamente no es primo
        # Consumir mensajes restantes para evitar que se acumulen
        consumir_mensajes_restantes(pendientes - 1)
        false
      
      {:verificacion, _primo, true} ->
        # No es divisible por este primo, continuar con el siguiente
        recoger_resultados(pendientes - 1, acumulador)
    after
      1000 -> 
        # Timeout, asumir que no es primo
        false
    end
  end

  # Consume mensajes restantes para evitar que se acumulen en el buzón
  defp consumir_mensajes_restantes(0), do: :ok
  defp consumir_mensajes_restantes(restantes) do
    receive do
      {:verificacion, _primo, _resultado} ->
        consumir_mensajes_restantes(restantes - 1)
    after
      10 -> :ok
    end
  end
end