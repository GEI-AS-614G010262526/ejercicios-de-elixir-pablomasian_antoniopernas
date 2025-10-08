# Criba de Eratóstenes - Versión Secuencial

Esta implementación utiliza el algoritmo clásico del Cribado de Eratóstenes de forma completamente secuencial, sin usar procesos de Elixir.

## Algoritmo

1. **Crear lista inicial**: Generamos una lista con todos los números desde 2 hasta `n`
2. **Cribar recursivamente**:
   - El primer número de la lista es primo
   - Filtramos todos los múltiplos de ese primo del resto de la lista
   - Repetimos el proceso con la lista filtrada

## Archivos

- `eratostenes.ex`: Implementación principal del módulo
- `eratostenes_test.exs`: Pruebas unitarias con ExUnit
- `test_manual.exs`: Script para pruebas manuales y medición de rendimiento

## Cómo usar

### Desde IEx (interactivo)
```bash
$ iex
iex> c "eratostenes.ex"
iex> Eratostenes.primos(30)
[2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
```

### Ejecutar pruebas
```bash
$ elixir -r eratostenes.ex eratostenes_test.exs
```

### Pruebas de rendimiento
```bash
$ elixir test_manual.exs
```

## Complejidad

- **Tiempo**: O(n log log n)
- **Espacio**: O(n) 
- **Concurrencia**: Ninguna (secuencial)

## Ejemplo de uso

```elixir
# Encontrar primos hasta 20
Eratostenes.primos(20)
# => [2, 3, 5, 7, 11, 13, 17, 19]

# Casos especiales
Eratostenes.primos(1)  # => []
Eratostenes.primos(2)  # => [2]
```