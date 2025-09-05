import 'package:flutter_test/flutter_test.dart';
import 'package:product/presentation/utils/emi_calculation.dart';

void main() {
  group('EmiCalculation', () {
    test('calculateMonthlyEmi', () {
      // Define test inputs
      double principal = 10000;
      double rate = 12;
      int tenure = 12;

      // Calculate expected result
      double expectedEmi = 888.4878867834168;

      // Call the method under test
      double calculatedEmi = EmiCalculation.calculateEMI(principal, rate, tenure);

      // Assert
      expect(calculatedEmi, equals(expectedEmi));
    });

    test('calculateTotalAmount', () {
      // Define test inputs
      double emiMonthly = 888.34;
      int tenure = 12;

      // Calculate expected result
      double expectedTotalAmount = 10660.08;

      // Call the method under test
      double calculatedTotalAmount = EmiCalculation.calculateTotalAmount(emiMonthly, tenure);

      // Assert
      expect(calculatedTotalAmount, expectedTotalAmount);
    });

    test('calculateTotalInterest', () {
      // Define test inputs
      double principal = 10000;
      double totalAmount = 10660.08;

      // Calculate expected result
      double expectedTotalInterest = 660.0799999999999;

      // Call the method under test
      double calculatedTotalInterest = EmiCalculation.calculateTotalInterest(principal, totalAmount);

      // Assert
      expect(calculatedTotalInterest, expectedTotalInterest);
    });
  });
}
