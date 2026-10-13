import 'package:flutter/material.dart';
import '../data/recetas_mock.dart';
import '../models/receta.dart';
import '../widgets/categoria_chips.dart';
import '../widgets/receta_card.dart';
import 'detalle_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _categoria = 'Todas';
  String _busqueda = '';

  List<Receta> get _filtradas {
    return recetasMock.where((r) {
      final okCat = _categoria == 'Todas' || r.categoria == _categoria;
      final okBusq =
          r.titulo.toLowerCase().contains(_busqueda.toLowerCase().trim());
      return okCat && okBusq;
    }).toList();
  }

  Future<void> _abrirDetalle(Receta receta) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetalleScreen(receta: receta)),
    );
    // Al volver, refresca por si cambió el estado de favorito.
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final recetas = _filtradas;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sabor Casero'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, size: 30),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Perfil: próximamente')),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              onChanged: (v) => setState(() => _busqueda = v),
              decoration: InputDecoration(
                hintText: 'Buscar receta...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          CategoriaChips(
            categorias: categorias,
            seleccionada: _categoria,
            onSeleccion: (c) => setState(() => _categoria = c),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: recetas.isEmpty
                ? const Center(child: Text('No se encontraron recetas 🍳'))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    itemCount: recetas.length,
                    itemBuilder: (context, i) => RecetaCard(
                      receta: recetas[i],
                      onTap: () => _abrirDetalle(recetas[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
