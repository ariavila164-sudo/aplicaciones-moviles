/// Contrato de almacenamiento del pasaporte.
///
/// Solo se guardan los IDs de los lugares visitados, NUNCA las coordenadas
/// del usuario. Así el pasaporte puede persistir sin comprometer su ubicación.
abstract class AlmacenPasaporte {
  Future<Set<String>> cargar();
  Future<void> guardar(Set<String> ids);
}
