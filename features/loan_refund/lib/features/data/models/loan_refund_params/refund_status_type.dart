enum RefundStatusType { refund, adjustment, nachHold}

extension RefundStatusTypeExtension on RefundStatusType {
  String get value {
    switch (this) {
      case RefundStatusType.adjustment:
        return '1';
      case RefundStatusType.nachHold:
        return '2';
      case RefundStatusType.refund:
        return '3';
      default:
        return '';
    }
  }
}
