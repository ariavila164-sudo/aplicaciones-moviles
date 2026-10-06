// Importa los widgets de Material Design: Scaffold, AppBar, TextField, etc.
import 'package:flutter/material.dart';

// Importa "services": nos da SystemNavigator (para cerrar la app) y
// FilteringTextInputFormatter (para limitar lo que se puede teclear).
import 'package:flutter/services.dart';

// main() es el punto de entrada: Dart siempre empieza a ejecutar aquí.
void main() {
  // runApp() coloca en pantalla el widget raíz de la aplicación.
  runApp(const MyApp());
}

// MyApp es un widget SIN estado (StatelessWidget): configura la app completa
// y no cambia mientras la app se ejecuta.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // build() describe qué se dibuja. Flutter lo llama automáticamente.
  @override
  Widget build(BuildContext context) {
    // MaterialApp aplica el estilo Material Design a toda la aplicación.
    return MaterialApp(
      title: 'Conociendo tu IMC',
      debugShowCheckedModeBanner: false, // quita la cinta "DEBUG"
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      // home: la primera pantalla que verá el usuario.
      home: const PantallaPrincipal(),
    );
  }
}

// ---------------------------------------------------------------------------
// FUNCIONES DE LÓGICA (fuera de la clase: no dependen de la pantalla)
// ---------------------------------------------------------------------------

// Calcula el IMC = peso / (estatura en metros)^2 y lo redondea a 1 decimal.
// Recibe el peso en kilogramos y la estatura en CENTÍMETROS.
double calcularImc(double pesoKg, double estaturaCm) {
  // Conversión de unidades: 165 cm -> 1.65 m
  final double estaturaM = estaturaCm / 100;

  // Fórmula del IMC.
  final double imc = pesoKg / (estaturaM * estaturaM);

  // toStringAsFixed(1) redondea y devuelve un String con 1 decimal ("25.0");
  // double.parse() lo vuelve a convertir en número (25.0).
  // Así clasificamos con el valor YA redondeado (24.96 -> 25.0 -> sobrepeso).
  return double.parse(imc.toStringAsFixed(1));
}

// Clasifica el IMC (ya redondeado) en una de las cuatro categorías.
String obtenerCategoria(double imc) {
  if (imc < 18.5) {
    return 'Bajo peso';
  } else if (imc < 25) {
    // Llegamos aquí solo si imc >= 18.5, así que el rango es 18.5 a 24.9
    return 'Peso normal';
  } else if (imc < 30) {
    // Rango 25.0 a 29.9
    return 'Sobrepeso';
  } else {
    // 30.0 o más
    return 'Obesidad';
  }
}

// Devuelve el mensaje de recomendación que corresponde a cada categoría.
String obtenerRecomendacion(String categoria) {
  switch (categoria) {
    case 'Bajo peso':
      return 'Te recomendamos mejorar tu alimentación.';
    case 'Peso normal':
      return '¡Sigue así, vas muy bien!';
    case 'Sobrepeso':
      return 'Te conviene cuidar tu alimentación y actividad física.';
    default:
      return 'Es importante buscar orientación profesional.';
  }
}

// PantallaPrincipal es un widget CON estado (StatefulWidget) porque el texto
// del resultado cambia mientras la app está en uso.
class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

// Esta clase guarda el estado (los datos que cambian) de la pantalla.
// El guion bajo (_) al inicio del nombre lo vuelve privado dentro del archivo.
class _PantallaPrincipalState extends State<PantallaPrincipal> {
  // ---------- CONTROLADORES ----------
  // Un TextEditingController permite leer y borrar lo que el usuario escribe.
  final TextEditingController _nombreCtrl = TextEditingController();
  final TextEditingController _pesoCtrl = TextEditingController();
  final TextEditingController _estaturaCtrl = TextEditingController();

  // ---------- VARIABLE DE ESTADO ----------
  // Texto que se muestra en la etiqueta de resultado. Empieza vacío.
  String _resultado = '';

  // dispose() se ejecuta cuando la pantalla se destruye.
  // Aquí liberamos la memoria que usan los controladores.
  @override
  void dispose() {
    _nombreCtrl.dispose();
    _pesoCtrl.dispose();
    _estaturaCtrl.dispose();
    super.dispose();
  }

  // Muestra una ventana emergente (diálogo) con un título y un mensaje.
  // Recibe dos parámetros de tipo String y no devuelve nada (void).
  void _mostrarDialogo(String titulo, String contenido) {
    showDialog(
      context: context, // "context" indica en qué pantalla se dibuja
      builder: (BuildContext contexto) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(contenido),
          actions: [
            TextButton(
              // Navigator.pop() cierra el diálogo.
              onPressed: () => Navigator.of(contexto).pop(),
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  // Método principal: lee los datos, los valida, calcula el IMC, lo clasifica
  // y muestra el resultado. Se ejecuta al presionar "Calcular IMC".
  void _calcular() {
    // Oculta el teclado quitando el foco de los campos de texto.
    FocusScope.of(context).unfocus();

    // ---------- 1) LEER LOS DATOS ----------
    // .text obtiene lo escrito; .trim() elimina espacios al inicio y al final.
    final String nombre = _nombreCtrl.text.trim();

    // Lo escrito siempre es texto (String); hay que convertirlo a número.
    // tryParse devuelve null (en lugar de un error) si no es un número válido.
    final double? peso = double.tryParse(_pesoCtrl.text.trim());
    final double? estatura = double.tryParse(_estaturaCtrl.text.trim());

    // ---------- 2) VALIDAR ----------
    // Si falta el nombre, o el peso, o la estatura (o alguno vale 0 o menos,
    // lo cual no tiene sentido y provocaría una división entre cero)...
    if (nombre.isEmpty ||
        peso == null ||
        estatura == null ||
        peso <= 0 ||
        estatura <= 0) {
      _mostrarDialogo(
        'Datos incompletos',
        'Por favor captura tu nombre completo, tu peso (kg) y tu estatura (cm).',
      );
      return; // termina el método aquí; el código de abajo no se ejecuta
    }

    // ---------- 3) CALCULAR Y CLASIFICAR ----------
    final double imc = calcularImc(peso, estatura);
    final String categoria = obtenerCategoria(imc);
    final String recomendacion = obtenerRecomendacion(categoria);

    // ---------- 4) ARMAR EL MENSAJE ----------
    // Interpolación de cadenas: $nombre se reemplaza por su valor;
    // ${...} permite insertar expresiones. \n es un salto de línea.
    final String mensaje = 'Hola, $nombre.\n'
        'Tu IMC es ${imc.toStringAsFixed(1)}.\n'
        'Estatus: $categoria.\n'
        '$recomendacion';

    // ---------- 5) MOSTRAR EL RESULTADO EN LA ETIQUETA ----------
    // setState avisa a Flutter que el estado cambió y que debe volver a
    // ejecutar build() para redibujar la pantalla con el nuevo valor.
    setState(() {
      _resultado = mensaje;
    });

    // ---------- 6) MOSTRAR EL RESULTADO EN UN DIÁLOGO ----------
    _mostrarDialogo('Resultado', mensaje);
  }

  // Borra los tres campos y la etiqueta de resultado.
  void _limpiar() {
    // clear() vacía el texto de cada campo.
    _nombreCtrl.clear();
    _pesoCtrl.clear();
    _estaturaCtrl.clear();

    // Vaciamos la etiqueta y pedimos redibujar la pantalla.
    setState(() {
      _resultado = '';
    });
  }

  // Cierra la aplicación (funciona en Android).
  void _salir() {
    SystemNavigator.pop();
  }

  // build() dibuja la pantalla.
  @override
  Widget build(BuildContext context) {
    // Scaffold es el "esqueleto" de una pantalla: barra superior + cuerpo.
    return Scaffold(
      // ---------- TÍTULO DE LA APP ----------
      appBar: AppBar(
        title: const Text('Conociendo tu IMC'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white, // color del texto de la barra
      ),

      // SingleChildScrollView permite desplazar la pantalla; así no se
      // "desborda" cuando aparece el teclado.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20), // margen interior de 20 px
        // Column acomoda a sus hijos uno debajo del otro (en vertical).
        child: Column(
          // stretch: los hijos ocupan todo el ancho disponible.
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Captura tus datos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            // SizedBox crea un espacio vacío entre widgets.
            const SizedBox(height: 16),

            // ---------- CAMPO 1: NOMBRE COMPLETO ----------
            TextField(
              controller: _nombreCtrl, // enlaza el campo con su controlador
              keyboardType: TextInputType.name,
              // Cada palabra inicia con mayúscula.
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Nombre completo',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // ---------- CAMPO 2: PESO (kg) ----------
            TextField(
              controller: _pesoCtrl,
              // decimal: true habilita el punto decimal en el teclado.
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              // Expresión regular: dígitos, un punto opcional y máximo
              // dos decimales. Ejemplo válido: 64.50
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: const InputDecoration(
                labelText: 'Peso (kg)',
                prefixIcon: Icon(Icons.monitor_weight),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // ---------- CAMPO 3: ESTATURA (cm) ----------
            TextField(
              controller: _estaturaCtrl,
              keyboardType: TextInputType.number, // teclado numérico
              // Solo permite dígitos (0-9): estatura en cm, enteros.
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Estatura (cm)',
                prefixIcon: Icon(Icons.height),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // ---------- BOTÓN 1: CALCULAR IMC ----------
            ElevatedButton.icon(
              onPressed: _calcular,
              icon: const Icon(Icons.calculate),
              label: const Text('Calcular IMC'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 12),

            // ---------- BOTÓN 2: LIMPIAR DATOS ----------
            OutlinedButton.icon(
              onPressed: _limpiar,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Limpiar datos'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 12),

            // ---------- BOTÓN 3: SALIR ----------
            TextButton.icon(
              onPressed: _salir,
              icon: const Icon(Icons.exit_to_app),
              label: const Text('Salir'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 24),

            // ---------- ETIQUETA DE RESULTADO ----------
            // Container con fondo y borde redondeado que contiene un Text.
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                border: Border.all(color: Colors.indigo.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                // Operador ternario: condición ? valor_si_true : valor_si_false
                _resultado.isEmpty ? 'Aquí aparecerá el resultado' : _resultado,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 8),

            // Aclaración opcional: el IMC no es un diagnóstico médico.
            const Text(
              'El IMC es una referencia general para personas adultas; '
              'no es un diagnóstico médico.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}