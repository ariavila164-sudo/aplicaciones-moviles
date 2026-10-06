import 'package:eco_ruta/model/residuo.dart';
import 'package:flutter/material.dart';

class ResiduoCard extends StatelessWidget {
  final Residuo residuo;
  final VoidCallback onTap;

  const ResiduoCard({
    super.key,
    required this.residuo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.recycling),
        title: Text(residuo.nombre),
        subtitle: Text('Tipo: ${residuo.tipo}'),
        onTap: onTap,
      ),
    );
  }
}
