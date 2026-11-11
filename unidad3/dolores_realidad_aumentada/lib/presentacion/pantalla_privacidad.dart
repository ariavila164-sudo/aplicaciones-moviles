import 'package:flutter/material.dart';

/// Aviso de privacidad claro y corto, dentro de la app (Ronda 9.4).
class PantallaPrivacidad extends StatelessWidget {
  const PantallaPrivacidad({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacidad y datos')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          _Seccion(
            icono: Icons.my_location,
            titulo: 'Qué datos usa Dolores AR',
            texto:
                'Para ubicar los lugares a tu alrededor usamos tu ubicación '
                '(solo mientras la app está abierta), la cámara como fondo y '
                'la brújula para saber hacia dónde miras.',
          ),
          _Seccion(
            icono: Icons.phone_android,
            titulo: 'Dónde se procesan',
            texto:
                'Todo el cálculo ocurre dentro de tu teléfono. La app no envía '
                'tu ubicación, tus imágenes ni tu rumbo a ningún servidor.',
          ),
          _Seccion(
            icono: Icons.badge_outlined,
            titulo: 'Tu pasaporte turístico',
            texto:
                'Solo guardamos los IDs de los lugares donde ganaste un sello '
                '(por ejemplo, "plaza"). No guardamos coordenadas ni rutas, y '
                'esa información nunca se comparte.',
          ),
          _Seccion(
            icono: Icons.tune,
            titulo: 'Tú decides los permisos',
            texto:
                'Puedes negar la ubicación o la cámara y seguir usando la app: '
                'el modo demo y la lista de lugares funcionan sin sensores. '
                'Pide solo lo necesario y puedes revocar los permisos en los '
                'ajustes del sistema.',
          ),
          _Seccion(
            icono: Icons.security,
            titulo: 'Seguridad al caminar',
            texto:
                'La realidad aumentada invita a mirar la pantalla. Mira a tu '
                'alrededor, cuida tu paso y no cruces la calle viendo el '
                'teléfono. Si no puedes o no quieres usar la cámara, usa la '
                'lista de lugares del inicio.',
          ),
          _Seccion(
            icono: Icons.school_outlined,
            titulo: 'Contexto',
            texto:
                'Proyecto académico de Desarrollo Móvil Integral (UTNG). Las '
                'coordenadas del catálogo son aproximadas y se corrigen en '
                'campo; el aviso se actualizará si cambian los datos tratados.',
          ),
        ],
      ),
    );
  }
}

class _Seccion extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String texto;

  const _Seccion({
    required this.icono,
    required this.titulo,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icono, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    titulo,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(texto),
          ],
        ),
      ),
    );
  }
}
