enum LoanType {
  personalLoan("Personal Loan", "Personal Loan"),
  vehicleLoan("Vehicle Loan", "Vehicle Loan");

  const LoanType(this.label, this.value);
  final String value;
  final String label;
}