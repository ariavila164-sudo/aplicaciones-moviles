import 'almacen_pasaporte.dart';
import 'lugar.dart';

/// Pasaporte turístico: ganas un sello al llegar a menos de 40 m de un lugar.
class Pasaporte {
  static const double radioSello = 40;
  final Set<String> _visitados = {};
  final AlmacenPasaporte? _almacen;

  /// [almacen] es opcional: sin él el pasaporte vive solo en memoria.
  Pasaporte({AlmacenPasaporte? almacen})
    : _almacen = almacen; // ignore: prefer_initializing_formals

  /// Recupera los sellos guardados. Si el almacenamiento falla, la app sigue
  /// funcionando con un pasaporte vacío.
  Future<void> cargar() async {
    final almacen = _almacen;
    if (almacen == null) return;
    try {
      _visitados.addAll(await almacen.cargar());
    } catch (_) {
      // La app no debe romperse por un fallo de almacenamiento.
    }
  }

  /// Devuelve true SOLO la primera vez que se gana el sello de ese lugar.
  bool registrarSiCerca(Lugar lugar, double distanciaMetros) {
    if (distanciaMetros > radioSello) return false;
    final esNuevo = _visitados.add(lugar.id);
    if (esNuevo) _guardar();
    return esNuevo;
  }

  void _guardar() {
    final almacen = _almacen;
    if (almacen == null) return;
    almacen.guardar(Set<String>.unmodifiable(_visitados)).ignore();
  }

  bool visitado(String id) => _visitados.contains(id);
  int get total => _visitados.length;
  double progreso(int totalLugares) =>
      totalLugares == 0 ? 0 : total / totalLugares;
}
