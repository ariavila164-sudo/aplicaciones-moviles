import 'package:fundamentos/singleton.dart';
import 'package:test/test.dart';


void main (){
  test('debe ser una sol instancia', (){
    final instance = Configuracion.instance;
    final instancia = Configuracion.instance;

    expect(instancia, same(instance));
    expect(identical(instancia, instance), true);

    print (instance.idioma);
  });
  
}