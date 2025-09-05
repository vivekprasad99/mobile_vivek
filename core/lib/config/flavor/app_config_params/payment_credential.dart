class PaymentCredential {
  final CamsPayCredential camsPayCredential;
  final PayUCredential payUCredential;
  PaymentCredential(
      {required this.camsPayCredential, required this.payUCredential});
}

class CamsPayCredential {
  final String merchantid;
  final String subbillerid;
  final String merchantidQR;
  final String subbilleridQR;
  final String merRefId;
  final String encKey;

  CamsPayCredential(
      {required this.merchantid,
      required this.subbillerid,
      required this.merchantidQR,
      required this.subbilleridQR,
      required this.merRefId,
      required this.encKey});
}

class PayUCredential {
  final String merchantKey;
  final String merchantSalt;

  PayUCredential({required this.merchantKey, required this.merchantSalt});
}
