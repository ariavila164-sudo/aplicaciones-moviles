import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: EcoMovimientoPage(),
    );
  }
}

class EcoMovimientoPage extends StatefulWidget{
  const EcoMovimientoPage();

  @override
  State<StatefulWidget> createState() => _EcoMovimientoPageState();
}

class _EcoMovimientoPageState extends State<EcoMovimientoPage>{
  StreamSubscription<AccelerometerEvent>? subscription;
  double x=0, y=0, z=0;
  int puntos = 0;
  bool bloqueado = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = accelerometerEventStream().listen(
      (event) {
        final fuerte = event.x.abs() > 12 || event.y.abs() > 12 || event.z.abs() > 16;
        setState(() {
          x = event.x;
          y = event.y;
          z = event.z;
          if(fuerte && !bloqueado){
            puntos++;
            bloqueado = true;
            Future.delayed(const Duration(milliseconds: 400), (){
              bloqueado = false;
            });
          }
        });
      }
    );
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    String nivel = 'sedentario';
    if (puntos>=20) nivel = 'Activo';
    if (puntos >= 50) nivel = 'Ecoatleta';

    return Scaffold(
      appBar: AppBar(title: const Text('Ecomovimiento'),),
      body: Padding(padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text('EcoPuntos: $puntos', style: const TextStyle(fontSize: 28),),
          Text('Nivel: $nivel'),
          const SizedBox(height: 30,),
          Text('x: ${x.toStringAsFixed(2)}'),
          Text('y: ${y.toStringAsFixed(2)}'),
          Text('z: ${z.toStringAsFixed(2)}'),
          const SizedBox(height: 20,),
          const Text('Mueve el telefono con cuidado para observar los cambios'),
        ],
      ),),
    );
  }

}
