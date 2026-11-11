import 'package:dolores_realidad_aumentada/dominio/almacen_pasaporte.dart';
import 'package:dolores_realidad_aumentada/dominio/pasaporte.dart';
import 'package:flutter_test/flutter_test.dart';

import 'ayudas_geo.dart';

class AlmacenFalso implements AlmacenPasaporte {
  Set<String> guardados;
  bool falla = false;

  AlmacenFalso([Set<String>? inicial]) : guardados = {...?inicial};

  @override
  Future<Set<String>> cargar() async {
    if (falla) throw StateError('almacén roto');
    return {...guardados};
  }

  @override
  Future<void> guardar(Set<String> ids) async {
    if (falla) throw StateError('almacén roto');
    guardados
      ..clear()
      ..addAll(ids);
  }
}

void main() {
  configurarFaseRojo();

  final plaza = lugarEn('plaza', origen);

  test('lejos de un lugar no hay sello', () {
    final p = Pasaporte();
    expect(p.registrarSiCerca(plaza, 120), false);
    expect(p.visitado('plaza'), false);
  });

  test('a menos de 40 m se gana el sello', () {
    final p = Pasaporte();
    expect(p.registrarSiCerca(plaza, 25), true);
    expect(p.visitado('plaza'), true);
    expect(p.total, 1);
  });

  test('exactamente a 40 m todavía cuenta', () {
    expect(Pasaporte().registrarSiCerca(plaza, 40), true);
  });

  test('el sello se gana una sola vez', () {
    final p = Pasaporte();
    expect(p.registrarSiCerca(plaza, 10), true);
    expect(p.registrarSiCerca(plaza, 10), false);
    expect(p.total, 1);
  });

  test('progreso es la fracción de lugares visitados', () {
    final p = Pasaporte()..registrarSiCerca(plaza, 5);
    expect(p.progreso(4), 0.25);
    expect(p.progreso(0), 0);
  });

  group('persistencia', () {
    test('cargar recupera los sellos guardados', () async {
      final almacen = AlmacenFalso({'plaza'});
      final p = Pasaporte(almacen: almacen);

      await p.cargar();

      expect(p.visitado('plaza'), true);
      expect(p.total, 1);
    });

    test('al ganar un sello se guarda solo el id del lugar', () async {
      final almacen = AlmacenFalso();
      final p = Pasaporte(almacen: almacen);

      expect(p.registrarSiCerca(plaza, 5), true);
      await pumpEventQueue();

      expect(almacen.guardados, {'plaza'});
      expect(almacen.guardados, isNot(contains(origen.toString())));
    });

    test('los sellos sobreviven entre pasaportes', () async {
      final almacen = AlmacenFalso();
      final p1 = Pasaporte(almacen: almacen)
        ..registrarSiCerca(lugarEn('plaza', origen), 5);
      await pumpEventQueue();
      expect(p1.visitado('plaza'), true);

      final p2 = Pasaporte(almacen: almacen);
      await p2.cargar();

      expect(p2.visitado('plaza'), true);
      expect(p2.total, 1);
    });

    test('si el almacén falla, el pasaporte sigue funcionando', () async {
      final almacen = AlmacenFalso()..falla = true;
      final p = Pasaporte(almacen: almacen);

      await p.cargar();
      expect(p.total, 0);
      expect(p.registrarSiCerca(plaza, 5), true);
    });
  });
}
