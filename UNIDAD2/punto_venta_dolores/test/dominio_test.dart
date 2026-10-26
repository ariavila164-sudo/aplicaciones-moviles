import 'package:flutter_test/flutter_test.dart';
import 'package:punto_venta_dolores/dominio/dinero.dart';
 
void main() {
  group('Dinero', () {
    test('formatea centavos', () {
      expect(formatearPesos(0), '\$0.00');
      expect(formatearPesos(5), '\$0.05');
      expect(formatearPesos(123456), '\$1,234.56');
    });
  });
}
