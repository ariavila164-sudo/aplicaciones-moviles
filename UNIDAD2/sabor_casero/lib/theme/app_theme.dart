import 'package:flutter/material.dart';

/// Paleta en gama de amarillos.
class AppTheme {
  static const Color primario = Color(0xFFFFC107); // amarillo ámbar
  static const Color oscuro = Color(0xFFF9A825); // amarillo dorado
  static const Color acento = Color(0xFFF57F17); // amarillo mostaza intenso
  static const Color claro = Color(0xFFFFF59D); // amarillo suave
  static const Color fondo = Color(0xFFFFFDE7); // crema amarillo
  static const Color texto = Color(0xFF4E342E); // café oscuro (buen contraste)

  // Alias usado en iconos secundarios.
  static const Color secundario = acento;

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: fondo,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primario,
          primary: primario,
          onPrimary: texto,
          secondary: acento,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: fondo,
          foregroundColor: texto,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: texto,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w800, color: texto),
          titleMedium: TextStyle(
              fontSize: 17, fontWeight: FontWeight.w700, color: texto),
          bodyMedium: TextStyle(fontSize: 14, height: 1.4, color: texto),
        ),
      );
}
