import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CategoriaChips extends StatelessWidget {
  final List<String> categorias;
  final String seleccionada;
  final ValueChanged<String> onSeleccion;

  const CategoriaChips({
    super.key,
    required this.categorias,
    required this.seleccionada,
    required this.onSeleccion,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categorias.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final cat = categorias[i];
          final activa = cat == seleccionada;
          return ChoiceChip(
            label: Text(cat),
            selected: activa,
            onSelected: (_) => onSeleccion(cat),
            selectedColor: AppTheme.primario,
            backgroundColor: Colors.white,
            side: BorderSide(color: activa ? AppTheme.oscuro : AppTheme.claro),
            labelStyle: const TextStyle(
              color: AppTheme.texto,
              fontWeight: FontWeight.w600,
            ),
            showCheckmark: false,
          );
        },
      ),
    );
  }
}
