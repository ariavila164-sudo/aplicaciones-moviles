// Ayudas compartidas por las pruebas (no es una prueba en sí).
import 'dart:math' as math;

import 'package:dolores_realidad_aumentada/dominio/geo.dart';
import 'package:dolores_realidad_aumentada/dominio/lugar.dart';
import 'package:flutter_test/flutter_test.dart';

/// Interruptor de demostración TDD.
///
/// En `true`, TODOS los tests fallan antes de ejecutar su cuerpo para poder
/// mostrar la fase ROJO en Visual Studio Code. Cambia a `false` para recuperar
/// la suite real (los 42 tests vuelven a pasar).
const bool forzarFaseRojo = false;

/// Registra el fallo intencional en la suite que lo invoque.
void configurarFaseRojo() {
  if (!forzarFaseRojo) return;
  setUp(() {
    fail('ROJO intencional (TDD): todavía no implementamos esta regla.');
  });
}

const origen = Coordenada(21.1561, -100.9318);

/// Mueve un punto [norte] metros hacia el norte y [este] metros hacia el este.
Coordenada desplazar(Coordenada c, {double norte = 0, double este = 0}) {
  const metrosPorGrado = 111194.93;
  return Coordenada(
    c.lat + norte / metrosPorGrado,
    c.lon + este / (metrosPorGrado * math.cos(c.lat * math.pi / 180)),
  );
}

Lugar lugarEn(String id, Coordenada c) => Lugar(
  id: id,
  nombre: id,
  emoji: '📍',
  categoria: Categoria.plaza,
  descripcion: '',
  datoCurioso: '',
  coordenada: c,
);
