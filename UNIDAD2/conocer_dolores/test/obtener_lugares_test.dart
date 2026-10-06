import 'package:flutter_test/flutter_test.dart';
import 'package:descubre_dolores/domain/entities/lugar_turistico.dart';
import 'package:descubre_dolores/domain/repositories/lugares_repository.dart';
import 'package:descubre_dolores/domain/usecases/obtener_lugares.dart';

class FakeLugaresRepository implements LugaresRepository {
  @override
  Future<List<LugarTuristico>> obtenerTodos() async => const [
        LugarTuristico(
          id: '1',
          nombre: 'Lugar de prueba',
          descripcion: 'Descripcion de prueba',
          imagenAsset: 'x.jpg',
          audioAsset: 'x.mp3',
        ),
      ];

  @override
  Future<LugarTuristico?> obtenerPorId(String id) async => null;
}

void main() {
  test('ObtenerLugares regresa la lista que entrega el repositorio', () async {
    final usecase = ObtenerLugares(FakeLugaresRepository());
    final resultado = await usecase();
    expect(resultado.length, 1);
    expect(resultado.first.nombre, 'Lugar de prueba');
  });
}
