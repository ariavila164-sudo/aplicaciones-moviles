class Receta {
  final int id;
  final String titulo;
  final String descripcion;
  final String imagen;
  final String emoji; // se muestra si la foto no carga
  final String categoria;
  final int minutos;
  final int porciones;
  final int costo; // costo aproximado en pesos MXN
  final String equipo; // lo mínimo que necesitas para cocinarla
  final double calificacion;
  final List<String> ingredientes;
  final List<String> pasos;
  bool favorito;

  Receta({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.imagen,
    required this.emoji,
    required this.categoria,
    required this.minutos,
    required this.porciones,
    required this.costo,
    required this.equipo,
    required this.calificacion,
    required this.ingredientes,
    required this.pasos,
    this.favorito = false,
  });
}
