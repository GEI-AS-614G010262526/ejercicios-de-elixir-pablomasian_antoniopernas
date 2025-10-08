# Criba de Eratóstenes - Versión Concurrente

Esta implementación utiliza procesos de Elixir para crear una cadena dinámica de filtros, donde cada proceso mantiene un número primo y filtra los múltiplos de ese primo.

## Algoritmo

1. **Proceso coordinador**: Maneja la cadena de filtros y recibe todos los números
2. **Cadena de filtros**: Cada proceso filtro mantiene un primo y filtra sus múltiplos
3. **Creación dinámica**: Los filtros se crean dinámicamente cuando se encuentra un nuevo primo
4. **Paso de mensajes**: Los números se pasan por la cadena hasta encontrar un primo o ser descartados

## Arquitectura de Procesos

```
Coordinador → Filtro(2) → Filtro(3) → Filtro(5) → ... → Filtro(último_primo)
```

Cada filtro:
- Recibe números y verifica si son múltiplos de su primo
- Si NO es múltiplo: lo pasa al siguiente filtro
- Si ES múltiplo: lo descarta
- Si llega al final de la cadena: es un nuevo primo

## Archivos

- `eratostenes.ex`: Implementación principal con procesos
- `eratostenes_test.exs`: Pruebas unitarias con ExUnit
- `test_manual.exs`: Script para pruebas manuales y análisis de concurrencia

## Cómo usar

### Desde IEx (interactivo)
```bash
$ iex
iex> c "eratostenes.ex"
iex> Eratostenes.primos(30)
[2, 3, 5, 7, 11, 13, 17, 19, 23, 29]

# Para observar los procesos en tiempo real
iex> :observer.start()
```

### Ejecutar pruebas
```bash
$ elixir -r eratostenes.ex eratostenes_test.exs
```

### Pruebas de concurrencia
```bash
$ elixir test_manual.exs
```

## Características

- **Concurrencia**: Cada primo tiene su propio proceso filtro
- **Creación dinámica**: Los procesos se crean conforme se encuentran primos
- **Tolerancia a fallos**: Los procesos son independientes
- **Paso de mensajes**: Comunicación asíncrona entre procesos

## Ventajas vs Versión Secuencial

- ✅ Demuestra conceptos de concurrencia en Elixir
- ✅ Cada filtro trabaja independientemente
- ✅ Escalabilidad teórica con múltiples cores
- ❌ Overhead de creación de procesos y paso de mensajes
- ❌ Para números pequeños puede ser más lento

## Ejemplo de uso

```elixir
# Encontrar primos hasta 50
Eratostenes.primos(50)
# => [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47]

# Observar procesos durante ejecución
spawn(fn -> 
  IO.puts("Procesos antes: #{length(Process.list())}")
  result = Eratostenes.primos(100)
  IO.puts("Procesos después: #{length(Process.list())}")
  IO.puts("Primos: #{length(result)}")
end)
```