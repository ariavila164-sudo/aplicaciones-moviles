import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/receta.dart';
import '../theme/app_theme.dart';
import '../widgets/receta_imagen.dart';

class DetalleScreen extends StatefulWidget {
  final Receta receta;

  const DetalleScreen({super.key, required this.receta});

  @override
  State<DetalleScreen> createState() => _DetalleScreenState();
}

class _DetalleScreenState extends State<DetalleScreen> {
  Receta get r => widget.receta;

  void _compartir() {
    final texto = '${r.titulo}\n\nIngredientes:\n'
        '${r.ingredientes.map((e) => '• $e').join('\n')}';
    Clipboard.setData(ClipboardData(text: texto));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Receta copiada al portapapeles')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppTheme.primario,
            foregroundColor: AppTheme.texto,
            actions: [
              IconButton(icon: const Icon(Icons.share), onPressed: _compartir),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'receta-${r.id}',
                child: RecetaImagen(receta: r),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.titulo, style: textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(r.descripcion, style: textTheme.bodyMedium),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _Dato(Icons.timer_outlined, '${r.minutos} min', 'Tiempo'),
                      _Dato(Icons.people_outline, '${r.porciones}', 'Porciones'),
                      _Dato(Icons.star_rounded, '${r.calificacion}', 'Valoración',
                          color: AppTheme.oscuro),
                      _Dato(Icons.payments_outlined, '~\$${r.costo}', 'Por porción'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.claro.withAlpha(140),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.soup_kitchen_outlined,
                            color: AppTheme.secundario),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text('Lo que necesitas: ${r.equipo}',
                              style: textTheme.bodyMedium),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text('Ingredientes', style: textTheme.headlineSmall),
                  const SizedBox(height: 12),
                  ...r.ingredientes.map(
                    (ing) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle,
                              size: 18, color: AppTheme.acento),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text(ing, style: textTheme.bodyMedium)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text('Preparación', style: textTheme.headlineSmall),
                  const SizedBox(height: 12),
                  ...List.generate(
                    r.pasos.length,
                    (i) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: AppTheme.primario,
                            child: Text('${i + 1}',
                                style: const TextStyle(
                                    color: AppTheme.texto,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                              child:
                                  Text(r.pasos[i], style: textTheme.bodyMedium)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              backgroundColor: r.favorito ? AppTheme.acento : AppTheme.primario,
              foregroundColor: AppTheme.texto,
            ),
            onPressed: () => setState(() => r.favorito = !r.favorito),
            icon: Icon(r.favorito ? Icons.favorite : Icons.favorite_border),
            label: Text(
              r.favorito ? 'Quitar de favoritos' : 'Agregar a favoritos',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  final IconData icono;
  final String valor;
  final String etiqueta;
  final Color color;

  const _Dato(this.icono, this.valor, this.etiqueta,
      {this.color = AppTheme.primario});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icono, color: color, size: 28),
        const SizedBox(height: 4),
        Text(valor, style: const TextStyle(fontWeight: FontWeight.w700)),
        Text(etiqueta,
            style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }
}
