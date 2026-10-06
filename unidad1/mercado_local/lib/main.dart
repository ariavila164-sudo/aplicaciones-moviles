import 'package:flutter/material.dart';
import 'package:mercado_local/producto.dart';

void main() => runApp(const MercadoApp());

class MercadoApp extends StatelessWidget {
  const MercadoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MercadoPage(),
    );
  }
}

class MercadoPage extends StatefulWidget {
  const MercadoPage({super.key});
  @override
  State<MercadoPage> createState() => _MercadoPageState();
}

class _MercadoPageState extends State<MercadoPage> {
  final productos = const [
  Producto(nombre: 'Maiz',precio: 12, productor: '', categoria: 'granos'),
  Producto(nombre: 'jitomate',precio: 15, productor: '', categoria: 'verdura'),
  ];
  String noombreBusca = '';
  String categoriaBusca = 'Todos';

  @override
  Widget build (BuildContext context){
    final visibles = productos.where((p){
      final nombre = p.nombre.toLowerCase();
      final categoria = p.categoria.toLowerCase();
      final coincidenciaNombre = nombre.contains(noombreBusca.toLowerCase());
      final coincidenciaCategoria = categoriaBusca == 'Todos' ||categoria == categoriaBusca.toLowerCase();
      return coincidenciaCategoria && coincidenciaNombre;
    }).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('mercado local')),
      body: Padding(
        padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'Buscar texto',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (valor) {
              setState(() => noombreBusca = valor);
            },
          ),
          const SizedBox(height: 16,),
          DropdownButton(value: categoriaBusca, isExpanded:true, items: [
            'Todos',
            'Granos',
            'Frutas',
            'Verduras'].map((opcion){
            return DropdownMenuItem(value: opcion, child: Text(opcion));
          }).toList(), onChanged: (valor){
            setState(() {
              categoriaBusca = valor!;
            });
          }),
          const SizedBox(height: 16,),
          Expanded(child: ListView.builder(
            itemCount: visibles.length,
            itemBuilder: (context, index){
              final p = visibles[index];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.eco),
                  ),
                  title: Text(p.nombre),
                  subtitle: Text(p.productor),
                  trailing: Text('\$ ${p.precio}'),
                ),
              );
            }))
        ],
      ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('proximamente: registrar producto')));
      },
      child: const Icon(Icons.add),
      ),
    );
  }


}

