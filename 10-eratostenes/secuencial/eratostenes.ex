defmodule Eratostenes do
  @moduledoc """
  Implementación secuencial del Cribado de Eratóstenes.
  
  Esta versión implementa el algoritmo clásico de forma completamente secuencial,
  sin usar procesos de Elixir.
  """

  @doc """
  Encuentra todos los números primos desde 2 hasta n usando el Cribado de Eratóstenes.
  
  ## Parámetros
  - n: número natural hasta el cual buscar primos
  
  ## Retorna
  Lista de todos los números primos entre 2 y n (inclusive)
  
  ## Ejemplos
      iex> Eratostenes.primos(10)
      [2, 3, 5, 7]
      
      iex> Eratostenes.primos(20)
      [2, 3, 5, 7, 11, 13, 17, 19]
  """
  def primos(n) when n < 2 do
    []
  end

  def primos(n) do
    # Creamos lista inicial de números del 2 hasta n
    numeros = Enum.to_list(2..n)
    
    # Aplicamos la criba
    cribar(numeros, [])
  end

  # Función auxiliar privada para implementar la criba recursivamente
  defp cribar([], primos_encontrados) do
    # Invertimos la lista para que esté en orden ascendente
    Enum.reverse(primos_encontrados)
  end

  defp cribar([primo | resto], primos_encontrados) do
    # El primer número es primo
    # Filtramos los múltiplos de este primo del resto de la lista
    resto_filtrado = Enum.filter(resto, fn x -> rem(x, primo) != 0 end)
    
    # Continuamos cribando con el resto filtrado
    cribar(resto_filtrado, [primo | primos_encontrados])
  end
end