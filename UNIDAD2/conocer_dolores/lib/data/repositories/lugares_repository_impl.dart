import '../../domain/entities/lugar_turistico.dart';
import '../../domain/repositories/lugares_repository.dart';
import '../datasources/lugares_local_datasource.dart';

class LugaresRepositoryImpl implements LugaresRepository {
  final LugaresLocalDataSource dataSource;
  LugaresRepositoryImpl(this.dataSource);

  @override
  Future<List<LugarTuristico>> obtenerTodos() async {
    return dataSource.obtenerLugares();
  }

  @override
  Future<LugarTuristico?> obtenerPorId(String id) async {
    final lugares = dataSource.obtenerLugares();
    for (final lugar in lugares) {
      if (lugar.id == id) return lugar;
    }
    return null;
  }
}
