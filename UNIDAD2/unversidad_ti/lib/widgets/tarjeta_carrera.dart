// Tarjeta reutilizable: una sola definición sirve para las cinco carreras.
import 'package:flutter/material.dart';
import 'package:unversidad_ti/models/carrera.dart';
import 'package:unversidad_ti/views/pantalla_contenido.dart';

class TarjetaCarrera extends StatelessWidget {
  final Carrera carrera;

  const TarjetaCarrera({required this.carrera});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias, // recorta el InkWell a las esquinas
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext contexto) =>
                  PantallaContenido(carrera: carrera),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // "Imagen representativa": un ícono dentro de un círculo
              // de color. No necesita archivos ni internet.
              CircleAvatar(
                radius: 30,
                backgroundColor: carrera.color,
                child: Icon(carrera.icono, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 12),
              Text(
                carrera.nombre,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
