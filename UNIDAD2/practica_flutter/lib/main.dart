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
      title: 'Conociendo a la persona',
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
  // ---------- CONSTANTES ----------
  // "static const": valor fijo que nunca cambia y es común a la clase.
  static const double sueldoMinimo = 9582.47; // double: número con decimales
  static const int edadMayoria = 18; // int: número entero
 
  // ---------- CONTROLADORES ----------
  // Un TextEditingController permite leer y borrar lo que el usuario escribe.
  final TextEditingController _nombreCtrl = TextEditingController();
  final TextEditingController _edadCtrl = TextEditingController();
  final TextEditingController _sueldoCtrl = TextEditingController();
 
  // ---------- VARIABLE DE ESTADO ----------
  // Texto que se muestra en la etiqueta de resultado. Empieza vacío.
  String _resultado = '';
 
  // dispose() se ejecuta cuando la pantalla se destruye.
  // Aquí liberamos la memoria que usan los controladores.
  @override
  void dispose() {
    _nombreCtrl.dispose();
    _edadCtrl.dispose();
    _sueldoCtrl.dispose();
    super.dispose();
  }
 
  // >>> AQUÍ escribirás los métodos de los pasos 7, 8 y 9 <<<
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
  // Método principal: lee los datos, los valida, aplica las reglas y
  // muestra el resultado. Se ejecutará al presionar "Verificar".
  void _verificar() {
    // Oculta el teclado quitando el foco de los campos de texto.
    FocusScope.of(context).unfocus();
 
    // ---------- 1) LEER LOS DATOS ----------
    // .text obtiene lo escrito; .trim() elimina espacios al inicio y al final.
    final String nombre = _nombreCtrl.text.trim();
 
    // Lo escrito siempre es texto (String); hay que convertirlo a número.
    // tryParse devuelve null (en lugar de un error) si no es un número válido.
    // El signo ? indica que la variable puede contener null (int? / double?).
    final int? edad = int.tryParse(_edadCtrl.text.trim());
    final double? sueldo = double.tryParse(_sueldoCtrl.text.trim());
 
    // ---------- 2) VALIDAR ----------
    // || significa "o". Si falta el nombre, o la edad, o el sueldo...
    if (nombre.isEmpty || edad == null || sueldo == null) {
      _mostrarDialogo(
        'Datos incompletos',
        'Por favor captura tu nombre completo, tu edad y tu sueldo mensual.',
      );
      return; // termina el método aquí; el código de abajo no se ejecuta
    }
 
    // ---------- 3) APLICAR LAS REGLAS ----------
    // Cada comparación produce un bool: true (verdadero) o false (falso).
    final bool esMayorDeEdad = edad >= edadMayoria; // 18 o más
    // Estrictamente mayor: si es igual al mínimo NO está "por arriba".
    final bool sueldoArribaDelMinimo = sueldo > sueldoMinimo;
 
    // ---------- 4) ARMAR LOS MENSAJES ----------
    String textoEdad;
    if (esMayorDeEdad) {
      textoEdad = 'Eres mayor de edad.';
    } else {
      textoEdad = 'Eres menor de edad.';
    }
 
    // toStringAsFixed(2) muestra el número con 2 decimales.
    final String minimoTexto = sueldoMinimo.toStringAsFixed(2);
 
    // \$ escribe un signo $ literal (la barra evita que Dart lo confunda con
    // una variable). $minimoTexto inserta el valor de la variable en el texto.
    String textoSueldo;
    if (sueldoArribaDelMinimo) {
      textoSueldo = 'Tu sueldo mensual SÍ está por arriba del '
          'sueldo mínimo (\$$minimoTexto).';
    } else {
      textoSueldo = 'Tu sueldo mensual NO está por arriba del '
          'sueldo mínimo (\$$minimoTexto).';
    }
 
    // Interpolación de cadenas: $nombre se reemplaza por su valor.
    // \n es un salto de línea.
    final String mensaje = 'Hola, $nombre.\n$textoEdad\n$textoSueldo';
 
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
    _edadCtrl.clear();
    _sueldoCtrl.clear();
 
    // Vaciamos la etiqueta y pedimos redibujar la pantalla.
    setState(() {
      _resultado = '';
    });
  }
 
  // Cierra la aplicación (funciona en Android).
  void _salir() {
    SystemNavigator.pop();
  }

 
  // build() dibuja la pantalla. Por ahora devuelve un Scaffold vacío.
  @override
  Widget build(BuildContext context) {
    // Scaffold es el "esqueleto" de una pantalla: barra superior + cuerpo.
    return Scaffold(
      // ---------- TÍTULO DE LA APP ----------
      appBar: AppBar(
        title: const Text('Conociendo a la persona'),
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
 
            // ---------- CAMPO 2: EDAD ----------
            TextField(
              controller: _edadCtrl,
              keyboardType: TextInputType.number, // teclado numérico
              // Solo permite dígitos (0-9): evita letras y signos.
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Edad',
                prefixIcon: Icon(Icons.cake),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
 
            // ---------- CAMPO 3: SUELDO MENSUAL ----------
            TextField(
              controller: _sueldoCtrl,
              // decimal: true habilita el punto decimal en el teclado.
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              // Expresión regular: dígitos, un punto opcional y máximo
              // dos decimales. Ejemplo válido: 12500.50
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: const InputDecoration(
                labelText: 'Sueldo mensual',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
 
            // ---------- BOTÓN 1: VERIFICAR ----------
            ElevatedButton.icon(
              onPressed: _verificar, // TEMPORAL: lo conectaremos en el paso 10
              icon: const Icon(Icons.check_circle),
              label: const Text('Verificar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 12),
 
            // ---------- BOTÓN 2: LIMPIAR DATOS ----------
            OutlinedButton.icon(
              onPressed: _limpiar, // TEMPORAL
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
              onPressed: _salir, // TEMPORAL
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
          ],
        ),
      ),
    );
  }

}


