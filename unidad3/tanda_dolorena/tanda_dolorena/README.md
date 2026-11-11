# Tanda Dolorena

Sistema de ahorro rotativo vecinal, construido con TDD siguiendo el Manual TDD.

## Estructura

- `lib/logica/servicio_tanda.dart`: reglas de negocio (Dart puro, sin Flutter).
- `lib/modelos/`: entidades `Participante`, `Tanda`, `CierreRonda`.
- `lib/presentation/tanda_screen.dart`: interfaz animada.
- `test/servicio_tanda_test.dart`: pruebas de cada regla y una prueba de integración.

## Ejecutar

```bash
flutter pub get
flutter test
flutter run
```

## Correcciones respecto al manual

- `cerrarRondaYAvanzar()` ahora devuelve `tandaYaTermino` si la tanda ya terminó, en vez de fallar por índice fuera de rango.
- Las pruebas de ciclo completo usan un helper `_completarRonda` en lugar de un bucle que ignoraba su variable.
- La pantalla deshabilita el cierre y muestra "Tanda terminada" al final.
