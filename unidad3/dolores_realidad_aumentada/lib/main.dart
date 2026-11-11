import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'datos/almacen_preferencias.dart';
import 'dominio/pasaporte.dart';
import 'presentacion/pantalla_inicio.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // La brújula y la cámara se comportan mejor con el teléfono en vertical.
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // El pasaporte sobrevive al cierre de la app: solo se guardan IDs.
  final pasaporte = Pasaporte(almacen: AlmacenPreferencias());
  await pasaporte.cargar();

  runApp(
    MaterialApp(
      title: 'Dolores AR',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepOrange, useMaterial3: true),
      home: PantallaInicio(pasaporte: pasaporte),
    ),
  );
}
