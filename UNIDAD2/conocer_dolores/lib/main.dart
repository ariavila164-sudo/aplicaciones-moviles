import 'package:flutter/material.dart';
import 'data/datasources/lugares_local_datasource.dart';
import 'data/repositories/lugares_repository_impl.dart';
import 'domain/usecases/obtener_lugares.dart';
import 'presentation/viewmodels/lugares_view_model.dart';
import 'presentation/views/lista_lugares_screen.dart';

void main() {
  // Composicion manual de dependencias: aqui, y solo aqui,
  // se conocen las clases concretas de las 3 capas.
  final dataSource = LugaresLocalDataSource();
  final repository = LugaresRepositoryImpl(dataSource);
  final obtenerLugares = ObtenerLugares(repository);
  final viewModel = LugaresViewModel(obtenerLugares);

  runApp(DescubreDoloresApp(viewModel: viewModel));
}

class DescubreDoloresApp extends StatelessWidget {
  final LugaresViewModel viewModel;
  const DescubreDoloresApp({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Descubre Dolores Hidalgo',
      theme: ThemeData(primarySwatch: Colors.brown, useMaterial3: true),
      home: ListaLugaresScreen(viewModel: viewModel),
    );
  }
}
