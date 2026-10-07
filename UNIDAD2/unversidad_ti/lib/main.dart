// ============================================================
// Práctica 3: Universidad TI
// Archivo: lib/main.dart
// ============================================================

// Importa los widgets de Material Design: Scaffold, AppBar, GridView, etc.
import 'package:flutter/material.dart';

// main() es el punto de entrada: Dart siempre empieza a ejecutar aquí.
void main() {
  // runApp() coloca en pantalla el widget raíz de la aplicación.
  runApp(const MyApp());
}

// MyApp configura la app completa: título, tema y cuál es la primera
// pantalla. No cambia mientras la app se ejecuta, por eso es Stateless.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Universidad TI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D47A1)),
        useMaterial3: true,
      ),
      // La primera pantalla que se ve al abrir la app.
      home: const PantallaPrincipal(),
    );
  }
}

// ---------------------------------------------------------------------
// MODELO: describe la información que necesita CADA carrera.
// ---------------------------------------------------------------------
class Carrera {
  final String nombre;
  final IconData icono;    // el ícono hace de "imagen representativa"
  final Color color;
  final String descripcion;

  const Carrera({
    required this.nombre,
    required this.icono,
    required this.color,
    required this.descripcion,
  });
}

// ---------------------------------------------------------------------
// ARREGLO: una sola lista con las cinco carreras. La rejilla y la
// pantalla de contenido leerán sus datos de aquí; nada más.
// ---------------------------------------------------------------------
const List<Carrera> carreras = [
  Carrera(
    nombre: 'Ingeniería en Desarrollo de Software',
    icono: Icons.code,
    color: Color(0xFF3F51B5),
    descripcion:
        'Forma profesionales capaces de diseñar, construir y mantener '
        'aplicaciones y sistemas de software de calidad, aplicando '
        'metodologías ágiles y buenas prácticas de programación para '
        'resolver problemas reales con tecnología.',
  ),
  Carrera(
    nombre: 'Ingeniería en Infraestructura de Redes',
    icono: Icons.hub,
    color: Color(0xFF00897B),
    descripcion:
        'Prepara especialistas en el diseño, instalación y administración '
        'de redes de datos, centros de cómputo y servicios en la nube, '
        'garantizando la conectividad, el rendimiento y la seguridad de '
        'la infraestructura tecnológica.',
  ),
  Carrera(
    nombre: 'Ingeniería en Inteligencia Artificial y Ciencia de Datos',
    icono: Icons.memory,
    color: Color(0xFF5E35B1),
    descripcion:
        'Combina matemáticas, programación y aprendizaje automático para '
        'desarrollar modelos y sistemas inteligentes capaces de analizar '
        'grandes volúmenes de información y apoyar la toma de decisiones.',
  ),
  Carrera(
    nombre: 'Licenciatura en Ciencia de Datos',
    icono: Icons.bar_chart,
    color: Color(0xFF1E88E5),
    descripcion:
        'Forma profesionales que recolectan, limpian, analizan y '
        'visualizan datos para convertirlos en información útil, '
        'combinando estadística, programación y conocimiento del negocio.',
  ),
  Carrera(
    nombre: 'Ingeniería en Ciberseguridad',
    icono: Icons.shield,
    color: Color(0xFF37474F),
    descripcion:
        'Prepara especialistas en proteger la información, las redes y '
        'los sistemas de una organización frente a amenazas digitales, '
        'mediante la identificación de vulnerabilidades y buenas '
        'prácticas de seguridad.',
  ),
];

// ---------------------------------------------------------------------
// PANTALLA 1: PRINCIPAL (rejilla de carreras)
// ---------------------------------------------------------------------
class PantallaPrincipal extends StatelessWidget {
  const PantallaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Universidad TI'),
        centerTitle: true,
      ),
      // GridView.builder arma la rejilla recorriendo el arreglo "carreras".
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: carreras.length, // tantas tarjetas como carreras haya
        // Describe la forma de la rejilla: 2 columnas y separación pareja.
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,     // <-- dos columnas
          mainAxisSpacing: 14,   // espacio vertical entre tarjetas
          crossAxisSpacing: 14,  // espacio horizontal entre tarjetas
          childAspectRatio: 0.85,
        ),
        // itemBuilder se ejecuta una vez por cada elemento del arreglo.
        itemBuilder: (BuildContext context, int indice) {
          final Carrera carrera = carreras[indice];
          return _TarjetaCarrera(carrera: carrera);
        },
      ),
    );
  }
}

// Tarjeta reutilizable: una sola definición sirve para las cinco carreras.
class _TarjetaCarrera extends StatelessWidget {
  final Carrera carrera;

  const _TarjetaCarrera({required this.carrera});

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

// ---------------------------------------------------------------------
// PANTALLA 2: CONTENIDO (detalle de una carrera)
// ---------------------------------------------------------------------
class PantallaContenido extends StatelessWidget {
  // Dato que recibimos de la pantalla principal.
  final Carrera carrera;

  const PantallaContenido({super.key, required this.carrera});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // El AppBar agrega SOLO por defecto la flecha de regreso, porque
      // esta pantalla se abrió con Navigator.push. Al tocarla, Flutter
      // hace exactamente lo mismo que Navigator.pop(context).
      appBar: AppBar(title: const Text('Contenido')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            // Misma imagen representativa que la tarjeta de origen.
            CircleAvatar(
              radius: 60,
              backgroundColor: carrera.color,
              child: Icon(carrera.icono, color: Colors.white, size: 60),
            ),
            const SizedBox(height: 20),
            Text(
              carrera.nombre,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              carrera.descripcion,
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
            // Spacer empuja el botón hacia la parte inferior de la pantalla.
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                // pop() cierra esta pantalla y regresa a la anterior.
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Regresar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}