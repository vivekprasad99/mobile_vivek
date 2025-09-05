enum PaymentProductType { vl, pl, plNext }

extension PaymentProductTypeExtension on PaymentProductType {
  String get value {
    switch (this) {
      case PaymentProductType.vl:
        return 'lbl_vehicle_loan';
      case PaymentProductType.pl:
        return 'lbl_personal_loan';
      case PaymentProductType.plNext:
        return "PLNext";
      default:
        return 'lbl_vehicle_loan';
    }
  }
}
