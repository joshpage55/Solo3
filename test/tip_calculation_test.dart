import 'package:flutter_test/flutter_test.dart';
import 'package:tip_calculator/models/tip_calculation.dart';

void main() {
  group('TipCalculation', () {
    test('calculates tip and total for standard input', () {
      const calc = TipCalculation(
        billAmount: 100,
        tipPercent: 20,
        splitCount: 1,
      );

      expect(calc.tipAmount, 20);
      expect(calc.totalAmount, 120);
      expect(calc.perPerson, 120);
    });

    test('splits total evenly across people', () {
      const calc = TipCalculation(
        billAmount: 50,
        tipPercent: 10,
        splitCount: 4,
      );

      expect(calc.tipAmount, 5);
      expect(calc.totalAmount, 55);
      expect(calc.perPerson, 13.75);
    });

    test('handles zero tip edge case', () {
      const calc = TipCalculation(
        billAmount: 25,
        tipPercent: 0,
        splitCount: 2,
      );

      expect(calc.tipAmount, 0);
      expect(calc.totalAmount, 25);
      expect(calc.perPerson, 12.5);
    });
  });
}
