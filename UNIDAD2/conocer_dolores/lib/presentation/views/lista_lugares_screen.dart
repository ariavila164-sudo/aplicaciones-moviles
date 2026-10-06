import 'package:flutter/material.dart';
import '../viewmodels/lugares_view_model.dart';
import 'detalle_lugar_screen.dart';

class ListaLugaresScreen extends StatefulWidget {
  final LugaresViewModel viewModel;
  const ListaLugaresScreen({super.key, required this.viewModel});

  @override
  State<ListaLugaresScreen> createState() => _ListaLugaresScreenState();
}

class _ListaLugaresScreenState extends State<ListaLugaresScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.cargar();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (context, _) {
        if (widget.viewModel.cargando) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Descubre Dolores Hidalgo')),
          body: ListView.builder(
            itemCount: widget.viewModel.lugares.length,
            itemBuilder: (context, i) {
              final lugar = widget.viewModel.lugares[i];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(lugar.imagenAsset, width: 56, height: 56, fit: BoxFit.cover),
                ),
                title: Text(lugar.nombre),
                subtitle: Text(lugar.descripcion, maxLines: 1, overflow: TextOverflow.ellipsis),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => DetalleLugarScreen(lugar: lugar),
                  ));
                },
              );
            },
          ),
        );
      },
    );
  }
}
