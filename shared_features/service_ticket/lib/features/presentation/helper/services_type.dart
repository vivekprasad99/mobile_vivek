enum Services {
  paymentAndChargesRelated,
  miscellaneous,
  refund
}

extension ServicesExtension on Services {
  String get value {
    switch (this) {
      case Services.paymentAndChargesRelated:
        return 'payment';
      case Services.miscellaneous:
        return 'miscellaneous';
      case Services.refund:
        return 'refund';
      default:
        return '';
    }
  }
}