import 'dart:math';

class EmiCalculation {
  static double calculateEMI(
      double principal, double annualInterestRate, int loanTenureInMonths) {
    // Convert annual interest rate to monthly rate
    double monthlyInterest = (annualInterestRate / 12) / 100;
    double emi = (principal *
            monthlyInterest *
            pow(1 + monthlyInterest, loanTenureInMonths)) /
        (pow(1 + monthlyInterest, loanTenureInMonths) - 1);
    return emi;
  }

  static double calculateTotalAmount(double emi, int tenure) {
    double totalAmount = emi * tenure;
    return totalAmount;
  }

  static double calculateTotalInterest(double principal, double totalAmount) {
    double totalInterest = totalAmount - principal;
    return totalInterest;
  }
}
