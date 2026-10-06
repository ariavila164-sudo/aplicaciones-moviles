import '../entities/lugar_turistico.dart';
import '../repositories/lugares_repository.dart';

class ObtenerLugares {
  final LugaresRepository repository;
  ObtenerLugares(this.repository);

  Future<List<LugarTuristico>> call() {
    return repository.obtenerTodos();
  }
}
