import 'package:shared_preferences/shared_preferences.dart';

import '../dominio/almacen_pasaporte.dart';

/// Guarda el pasaporte en las preferencias locales del teléfono.
///
/// Solo se persisten los IDs de los lugares visitados, nunca coordenadas.
class AlmacenPreferencias implements AlmacenPasaporte {
  static const clave = 'pasaporte_sellos';

  @override
  Future<Set<String>> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(clave) ?? const <String>[]).toSet();
  }

  @override
  Future<void> guardar(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    final ordenados = ids.toList()..sort();
    await prefs.setStringList(clave, ordenados);
  }
}
