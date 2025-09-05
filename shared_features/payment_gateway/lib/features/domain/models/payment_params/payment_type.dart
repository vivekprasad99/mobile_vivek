enum PaymentType { forceclose, loancancel, emi, noc }

extension PaymentTypeExtension on PaymentType {
  String get value {
    switch (this) {
      case PaymentType.forceclose:
        return 'Foreclosure';
      case PaymentType.loancancel:
        return 'LoanCancellation';
      case PaymentType.emi:
        return 'EMI';
      case PaymentType.noc:
        return 'NOC';
      default:
        return 'Foreclosure';
    }
  }
}
