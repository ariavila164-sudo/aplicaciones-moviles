import '../../domain/entities/lugar_turistico.dart';

class LugaresLocalDataSource {
  List<LugarTuristico> obtenerLugares() {
    return [
      const LugarTuristico(
        id: '1',
        nombre: 'Jardin Principal',
        descripcion: 'El corazon de Dolores Hidalgo, rodeado de portales y cafes.',
        imagenAsset: 'assets/images/jardin_principal.jpg',
        audioAsset: 'audio/jardin_principal.mp3',
        videoAsset: 'assets/video/jardin_principal.mp4',
      ),
      const LugarTuristico(
        id: '2',
        nombre: 'Parroquia de Nuestra Senora de los Dolores',
        descripcion: 'El lugar donde Miguel Hidalgo dio el Grito de Independencia en 1810.',
        imagenAsset: 'assets/images/parroquia.jpg',
        audioAsset: 'audio/parroquia.mp3',
      ),
      const LugarTuristico(
        id: '3',
        nombre: 'Museo Casa de Hidalgo',
        descripcion: 'La casa donde vivio el cura Miguel Hidalgo antes de la Independencia.',
        imagenAsset: 'assets/images/museo_hidalgo.jpg',
        audioAsset: 'audio/museo_hidalgo.mp3',
      ),
    ];
  }
}
