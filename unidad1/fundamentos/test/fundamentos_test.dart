
import 'package:fundamentos/fundamentos.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    expect(calculate(), 42);
  });

  test ('sumar',(){
    int resultado = sumar (10,20);
    expect(resultado, 30);
  });

  test('restar', (){
    double resultado = restar(15.5, 5.5);
    expect(resultado, 10.0);
  });

  test('saludar', (){
    String resultado = saludar("Ari");
    expect(resultado, "Hola Ari");
  });

  test ('Datos', (){
    String resultado = listaDatos(['Manzana','Pera','Platano']);
    expect(resultado, 'ManzanaPeraPlatano');
  });
}
