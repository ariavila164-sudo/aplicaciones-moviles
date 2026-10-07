// ============================================================
// Práctica 3: Universidad TI
// Archivo: lib/main.dart
// ============================================================

// Importa los widgets de Material Design: Scaffold, AppBar, GridView, etc.
import 'package:flutter/material.dart';
import 'package:unversidad_ti/views/pantalla_princial.dart';

// main() es el punto de entrada: Dart siempre empieza a ejecutar aquí.
void main() {
  // runApp() coloca en pantalla el widget raíz de la aplicación.
  runApp(const MyApp());
}

// MyApp configura la app completa: título, tema y cuál es la primera
// pantalla. No cambia mientras la app se ejecuta, por eso es Stateless.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Universidad TI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D47A1)),
        useMaterial3: true,
      ),
      // La primera pantalla que se ve al abrir la app.
      home: const PantallaPrincipal(),
    );
  }
}


