import 'package:flutter/material.dart';
import '../models/receta.dart';
import '../theme/app_theme.dart';

/// Foto de la receta con indicador de carga y respaldo en amarillo + emoji.
class RecetaImagen extends StatelessWidget {
  final Receta receta;
  final double? height;

  const RecetaImagen({super.key, required this.receta, this.height});

  Widget _respaldo() => Container(
        height: height,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.claro, AppTheme.oscuro],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        alignment: Alignment.center,
        child: Text(receta.emoji, style: const TextStyle(fontSize: 72)),
      );

  @override
  Widget build(BuildContext context) {
    return Image.network(
      receta.imagen,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) => progress == null
          ? child
          : Container(
              height: height,
              color: AppTheme.claro,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(color: AppTheme.acento),
            ),
      errorBuilder: (_, __, ___) => _respaldo(),
    );
  }
}
