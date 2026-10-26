import 'package:flutter_test/flutter_test.dart';
import 'package:punto_venta_dolores/dominio/dinero.dart';
 
void main() {
  group('Dinero', () {
    test('convierte texto a centavos', () {
      expect(pesosACentavos('12.5'), 1250);
      expect(pesosACentavos('\$1,200'), 120000);
      expect(pesosACentavos('0.07'), 7);
    });
    test('rechaza texto inválido', () {
      expect(() => pesosACentavos(''), throwsFormatException);
      expect(() => pesosACentavos('1.2.3'), throwsFormatException);
    });

    test('formatea centavos', () {
      expect(formatearPesos(0), '\$0.00');
      expect(formatearPesos(5), '\$0.05');
      expect(formatearPesos(123456), '\$1,234.56');
    });
  });
}
