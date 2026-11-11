import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

/// AR de superficie: el visitante coloca la campana sobre el piso o una mesa.
///
/// En Android se lanza con Scene Viewer (ARCore). El modelo es local, así que
/// no depende de internet ni de licencias de terceros. Para iPhone haría falta
/// una versión .usdz y el parámetro [ModelViewer.iosSrc].
class PantallaModelo3D extends StatelessWidget {
  static const modeloLocal = 'assets/modelos/campana.glb';

  const PantallaModelo3D({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campana en tu espacio')),
      body: Column(
        children: [
          Expanded(
            child: ModelViewer(
              src: modeloLocal,
              alt: 'Campana de Dolores en 3D',
              ar: true,
              arModes: const ['scene-viewer', 'webxr'],
              autoRotate: true,
              cameraControls: true,
              shadowIntensity: 1,
              cameraOrbit: '25deg 72deg 2.4m',
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Row(
                children: [
                  const Icon(Icons.view_in_ar, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Campana de Dolores · modelo local. '
                      'Toca el ícono de RA para colocarla en el piso.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
