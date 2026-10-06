import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: semaforoAgua(),
    );
  }
}

class semaforoAgua extends StatefulWidget {
  const semaforoAgua({super.key});

  @override
  State<semaforoAgua> createState() => _semaforoAguaState();
}

class _semaforoAguaState extends State<semaforoAgua>{
  int nivel = 0;
  String mensaje = 'Presiona el boton para comensar';

  void CambiarNivel(){
    setState(() {
      nivel ++;
      if (nivel>2) nivel = 0;

      if (nivel ==0){
        mensaje = 'Consumo responsable';
      }else if (nivel ==1){
        mensaje = 'Cuidado con el consumo';
      }else {
        mensaje = 'consumo excesivo';
      }

    });
  }

  Color get colorSemaforo {
    switch(nivel){
      case 0 :return Colors.green;
      case 1: return Colors.yellow;
      default: return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Semaforo de electricidad"),
      ),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon (Icons.electric_bolt, size: 48,color: colorSemaforo,),
        Text(mensaje, textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 26),),
        const SizedBox(height: 30,),
        ElevatedButton(onPressed: CambiarNivel,
        child: const Text('cambiar Nivel')),
      ],),),
    );
  }

}
