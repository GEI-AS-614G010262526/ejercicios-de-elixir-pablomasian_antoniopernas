# Proyecto Cribado de Eratóstenes - Resumen

¡Felicidades! Has creado exitosamente ambas implementaciones del Cribado de Eratóstenes en Elixir.

## Estado del Proyecto: ✅ COMPLETADO

### Archivos Creados

#### Versión Secuencial (`10-eratostenes/secuencial/`)
- ✅ `eratostenes.ex` - Implementación principal
- ✅ `eratostenes_test.exs` - Pruebas unitarias (7 tests)
- ✅ `test_manual.exs` - Script de pruebas manuales y benchmarks
- ✅ `README.md` - Documentación específica

#### Versión Concurrente (`10-eratostenes/concurrente/`)
- ✅ `eratostenes.ex` - Implementación con procesos
- ✅ `eratostenes_test.exs` - Pruebas unitarias (8 tests)
- ✅ `test_manual.exs` - Script de pruebas manuales y análisis de concurrencia
- ✅ `README.md` - Documentación específica

## Cómo Ejecutar

### Prueba Rápida
```bash
# Versión Secuencial
cd 10-eratostenes/secuencial
elixir -e "Code.require_file(\"eratostenes.ex\"); IO.inspect(Eratostenes.primos(30))"

# Versión Concurrente  
cd ../concurrente
elixir -e "Code.require_file(\"eratostenes.ex\"); IO.inspect(Eratostenes.primos(30))"
```

### Tests Unitarios
```bash
# Secuencial (7 tests)
cd 10-eratostenes/secuencial
elixir -r eratostenes.ex -e "ExUnit.start()" -r eratostenes_test.exs -e "ExUnit.run()"

# Concurrente (8 tests)
cd ../concurrente  
elixir -r eratostenes.ex -e "ExUnit.start()" -r eratostenes_test.exs -e "ExUnit.run()"
```

### Benchmarks y Análisis
```bash
# Secuencial
cd 10-eratostenes/secuencial
elixir test_manual.exs

# Concurrente
cd ../concurrente
elixir test_manual.exs
```

### Modo Interactivo
```bash
cd 10-eratostenes/secuencial  # o concurrente
iex
iex> c "eratostenes.ex"
iex> Eratostenes.primos(50)

# Para versión concurrente, puedes observar procesos:
iex> :observer.start()
```

## Resultados de Ejemplo

Ambas implementaciones producen los mismos resultados correctos:

```elixir
Eratostenes.primos(30)
# => [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]

Eratostenes.primos(50) 
# => [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47]
```

## Diferencias Clave

- **Secuencial**: Algoritmo clásico, más eficiente para números pequeños
- **Concurrente**: Utiliza procesos Elixir, demuestra conceptos de concurrencia

## Próximos Pasos

Tu proyecto está listo para:
1. ✅ Desarrollo y pruebas
2. ✅ Análisis de rendimiento
3. ✅ Comparación entre enfoques
4. 📝 Documentación adicional si es necesario
5. 🎯 ¡Continuar con el siguiente ejercicio!

¡Buen trabajo implementando estos algoritmos fundamentales en Elixir! 🎉