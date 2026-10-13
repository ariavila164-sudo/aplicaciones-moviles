import 'package:flutter/material.dart';
import '../models/receta.dart';
import '../theme/app_theme.dart';
import 'receta_imagen.dart';

class RecetaCard extends StatelessWidget {
  final Receta receta;
  final VoidCallback onTap;

  const RecetaCard({super.key, required this.receta, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shadowColor: AppTheme.oscuro.withAlpha(120),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'receta-${receta.id}',
              child: RecetaImagen(receta: receta, height: 180),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(receta.titulo,
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                      const Icon(Icons.star, color: AppTheme.oscuro, size: 18),
                      const SizedBox(width: 4),
                      Text('${receta.calificacion}'),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    receta.descripcion,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined,
                          size: 16, color: AppTheme.acento),
                      const SizedBox(width: 4),
                      Text('${receta.minutos} min'),
                      const SizedBox(width: 16),
                      const Icon(Icons.attach_money,
                          size: 16, color: AppTheme.acento),
                      Text('~\$${receta.costo} por porción'),
                      const Spacer(),
                      if (receta.favorito)
                        const Icon(Icons.favorite,
                            color: Colors.red, size: 18),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
