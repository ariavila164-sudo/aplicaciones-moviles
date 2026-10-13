import 'package:flutter_test/flutter_test.dart';
import 'package:vota_dolores/logica/resultado_voto.dart';
import 'package:vota_dolores/logica/servicio_votacion.dart';
import 'package:vota_dolores/modelos/opcion_votacion.dart';
import 'package:vota_dolores/modelos/votacion.dart';


Votacion _crearVotacionDePrueba({DateTime? fechaCierre}) {
  return Votacion(
    pregunta: 'Pregunta de prueba',
    opciones: [
      OpcionVotacion(id: 'op1', texto: 'Opcion 1'),
      OpcionVotacion(id: 'op2', texto: 'Opcion 2'),
    ],
    fechaCierre: fechaCierre ?? DateTime.now().add(const Duration(days: 7)),
  );
}

void main() {
  test('registrar un voto valido incrementa el contador de esa opcion', () {
    final votacion = _crearVotacionDePrueba();
    final servicio = ServicioVotacion(votacion);

    final resultado = servicio.registrarVoto(idUsuario: 'user1', idOpcion: 'op1');

    expect(resultado, ResultadoVoto.exitoso);
    expect(votacion.opciones[0].votos, 1);
  });
    test('votar por una opcion que no existe regresa opcionInvalida', () {
    final votacion = _crearVotacionDePrueba();
    final servicio = ServicioVotacion(votacion);

    final resultado = servicio.registrarVoto(idUsuario: 'user1', idOpcion: 'no-existe');

    expect(resultado, ResultadoVoto.opcionInvalida);
  });
  
}
