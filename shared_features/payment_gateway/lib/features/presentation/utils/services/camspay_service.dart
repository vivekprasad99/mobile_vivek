import 'package:payment_gateway/features/data/models/payment_cred_response_model.dart';

class CAMPSPayService {
  static String merchantid = '';
  static String subbillerid = '';
  static String merRefId = '';
  static String encKey = '';
  static String toolbarTitle = "toolbarTitle";

  static void setCamsPayCred(
      {required bool isQRPayment,
      required isPennant,
      required CamsPay camsPay}) {
    if (isPennant) {
      merchantid = camsPay.personalLoan.merchantId;
      subbillerid = camsPay.personalLoan.subBillerId;
      merRefId = camsPay.personalLoan.checkSumKey;
      encKey = camsPay.personalLoan.reqEncryptionKey;
    } else {
      merchantid = camsPay.vehicleLoan.merchantId;
      subbillerid = camsPay.vehicleLoan.subBillerId;
      merRefId = camsPay.vehicleLoan.checkSumKey;
      encKey = camsPay.vehicleLoan.reqEncryptionKey;
    }
  }
}
