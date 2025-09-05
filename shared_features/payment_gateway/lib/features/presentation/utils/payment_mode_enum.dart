enum PaymentModeEnum {
  upi("UPI"),
  card("CARD"),
  qrCode("QR"),
  wallets("WALLET"),
  netBanking("NB"),
  addNewmode("ADDNEWMODE");

  const PaymentModeEnum(this.name);

  final String name;
}

enum PaymentSDKType { camspay, payU }


extension PaymentProductTypeExtension on PaymentModeEnum {
  String get value {
    switch (this) {
      case PaymentModeEnum.netBanking:
        return 'Net Banking';
      case PaymentModeEnum.card:
        return 'Debit Card';
      case PaymentModeEnum.upi:
        return 'UPI';
      case PaymentModeEnum.qrCode:
        return 'QR Code';
      case PaymentModeEnum.wallets:
        return 'Wallet';
      default:
        return 'Debit Card';
    }
  }
}

enum PaymentStatusEnum {
  failure("FAILURE"),
  pending("PENDING"),
  success("SUCCESS");

  const PaymentStatusEnum(this.name);

  final String name;
}

enum ActionType{
  download("download"),
  share("share");
  const ActionType(this.name);
  final String name;
}