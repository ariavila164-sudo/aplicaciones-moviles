class LugarTuristico {
  final String id;
  final String nombre;
  final String descripcion;
  final String imagenAsset;
  final String audioAsset;
  final String? videoAsset;

  const LugarTuristico({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.imagenAsset,
    required this.audioAsset,
    this.videoAsset,
  });
}
