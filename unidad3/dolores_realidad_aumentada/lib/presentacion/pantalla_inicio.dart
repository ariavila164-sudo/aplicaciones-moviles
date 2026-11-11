import 'package:flutter/material.dart';

import '../datos/fuentes_reales.dart';
import '../datos/fuentes_simuladas.dart';
import '../dominio/catalogo.dart';
import '../dominio/geo.dart';
import '../dominio/lugar.dart';
import '../dominio/pasaporte.dart';
import 'ar_viewmodel.dart';
import 'pantalla_ar.dart';
import 'pantalla_modelo3d.dart';
import 'pantalla_privacidad.dart';

class PantallaInicio extends StatefulWidget {
  final Pasaporte pasaporte;
  const PantallaInicio({super.key, required this.pasaporte});

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  Future<void> _abrir(Widget pantalla) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => pantalla),
    );
    // Al volver, refresca las palomitas del pasaporte.
    if (mounted) setState(() {});
  }

  void _irReal() {
    _abrir(
      PantallaAr(
        crearVm: () => ArViewModel(
          posicion: PosicionGps(),
          brujula: BrujulaReal(),
          lugares: catalogoDolores,
          pasaporte: widget.pasaporte,
        ),
      ),
    );
  }

  Future<void> _irDemo() async {
    // Te "teletransporta" a la Plaza Principal para practicar en el salón.
    final brujula = BrujulaSimulada();
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => PantallaAr(
          crearVm: () => ArViewModel(
            posicion: PosicionSimulada(const Coordenada(21.15600, -100.93175)),
            brujula: brujula,
            lugares: catalogoDolores,
            pasaporte: widget.pasaporte,
          ),
          controlesDemo: _DeslizadorRumbo(brujula: brujula),
        ),
      ),
    );
    brujula.cerrar();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dolores AR'),
        actions: [
          IconButton(
            tooltip: 'Privacidad y datos',
            icon: const Icon(Icons.privacy_tip_outlined),
            onPressed: () => _abrir(const PantallaPrivacidad()),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Descubre Dolores Hidalgo con realidad aumentada',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text(
            'Apunta tu teléfono y mira qué lugares históricos te rodean.',
          ),
          const SizedBox(height: 12),
          Card(
            color: Theme.of(context).colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Mira a tu alrededor, cuida tu paso y no cruces la calle viendo el teléfono.',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _irReal,
            icon: const Icon(Icons.explore),
            label: const Text('Explorar con GPS real'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: _irDemo,
            icon: const Icon(Icons.school),
            label: const Text('Modo demo (salón de clases)'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => _abrir(const PantallaModelo3D()),
            icon: const Icon(Icons.view_in_ar),
            label: const Text('Modelo 3D en tu espacio'),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Tu ubicación es privada'),
              subtitle: const Text(
                'Se procesa en tu teléfono y no se envía a ningún servidor. '
                'Toca para leer el aviso completo.',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _abrir(const PantallaPrivacidad()),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Lugares del recorrido',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(
                '${widget.pasaporte.total}/${catalogoDolores.length} sellos',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: widget.pasaporte.progreso(catalogoDolores.length),
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 4),
          for (final l in catalogoDolores)
            ListTile(
              leading: Text(l.emoji, style: const TextStyle(fontSize: 26)),
              title: Text(l.nombre),
              subtitle: Text(
                '${widget.pasaporte.visitado(l.id) ? 'Visitado' : 'Sin visitar'} · '
                '${_categoria(l.categoria)}',
              ),
              trailing: Icon(
                widget.pasaporte.visitado(l.id)
                    ? Icons.verified
                    : Icons.circle_outlined,
              ),
            ),
        ],
      ),
    );
  }

  String _categoria(Categoria categoria) => switch (categoria) {
    Categoria.historia => 'Historia',
    Categoria.museo => 'Museo',
    Categoria.plaza => 'Plaza',
    Categoria.musica => 'Música',
    Categoria.gastronomia => 'Gastronomía',
  };
}

class _DeslizadorRumbo extends StatefulWidget {
  final BrujulaSimulada brujula;
  const _DeslizadorRumbo({required this.brujula});

  @override
  State<_DeslizadorRumbo> createState() => _DeslizadorRumboState();
}

class _DeslizadorRumboState extends State<_DeslizadorRumbo> {
  double _grados = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Text('Gira:', style: TextStyle(color: Colors.white)),
          Expanded(
            child: Slider(
              min: 0,
              max: 359,
              value: _grados,
              onChanged: (g) {
                setState(() => _grados = g);
                widget.brujula.girar(g);
              },
            ),
          ),
          Text(
            '${_grados.round()}°',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
