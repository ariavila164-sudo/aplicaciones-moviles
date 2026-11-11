import 'package:geolocator/geolocator.dart';

/// Abre el ajuste correcto: primero el GPS del sistema y, si ya está
/// encendido, los permisos de la app.
Future<void> abrirAjustesDeUbicacion() async {
  if (!await Geolocator.isLocationServiceEnabled()) {
    await Geolocator.openLocationSettings();
  } else {
    await Geolocator.openAppSettings();
  }
}
