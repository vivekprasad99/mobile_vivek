
import 'package:core/config/flavor/app_config.dart';
import 'package:core/utils/utils.dart';
import 'package:payment_gateway/features/data/models/payment_cred_response_model.dart';
import 'package:payu_checkoutpro_flutter/PayUConstantKeys.dart';


class PayUTestCredentials {
  static String merchantKey = "";
  static String iosSurl = "";
  static String iosFurl = "";
  static String androidSurl = "";
  static String androidFurl = "";

  static void setPayuCred({required bool isPennant, required Payu payu}) {
    if (isPennant) {
      merchantKey = payu.personalLoan.merchantId;
    } else {
      merchantKey = payu.vehicleLoan.merchantId;
    }
    iosSurl = payu.payuConstant.iosSurl;
    iosFurl = payu.payuConstant.iosFurl;
    androidSurl = payu.payuConstant.androidSurl;
    androidFurl = payu.payuConstant.androidFurl;
  } 
  

  static const merchantAccessKey = ""; //Add Merchant Access Key - Optional
  static const sodexoSourceId = ""; //Add sodexo Source Id - Optional
}

class PayUParams {
  static Map createPayUPaymentParams({required String amount, required String transactionId}) {


    var additionalParam = {
      PayUAdditionalParamKeys.udf1: AppConfig.shared.flavor.name,
      PayUAdditionalParamKeys.udf2: "udf2",
      PayUAdditionalParamKeys.udf3: "udf3",
      PayUAdditionalParamKeys.udf4: "udf4",
      PayUAdditionalParamKeys.udf5: "udf5",
      PayUAdditionalParamKeys.merchantAccessKey:
          PayUTestCredentials.merchantAccessKey,
      PayUAdditionalParamKeys.sourceId: PayUTestCredentials.sodexoSourceId,
    };

    var payUPaymentParams = {
      PayUPaymentParamKey.key: PayUTestCredentials.merchantKey,
      PayUPaymentParamKey.amount: amount,
      PayUPaymentParamKey.productInfo: "Info",
      PayUPaymentParamKey.firstName: "Abc",
      PayUPaymentParamKey.email: "test@gmail.com",
      PayUPaymentParamKey.phone: getPhoneNumber(),  
      PayUPaymentParamKey.ios_surl: PayUTestCredentials.iosSurl,
      PayUPaymentParamKey.ios_furl: PayUTestCredentials.iosFurl,
      PayUPaymentParamKey.android_surl: PayUTestCredentials.androidSurl,
      PayUPaymentParamKey.android_furl: PayUTestCredentials.androidFurl, 
      PayUPaymentParamKey.environment: "1", //0 => Production 1 => Test
      PayUPaymentParamKey.userCredential: 'test user credential',
      PayUPaymentParamKey.transactionId:transactionId,
      PayUPaymentParamKey.additionalParam: additionalParam,
      PayUPaymentParamKey.enableNativeOTP: true,

    };

    return payUPaymentParams;
  }

  static Map createPayUConfigParams({required String paymentType}) {

    var enforcePaymentList = [
      {"payment_type": paymentType,},
    ];



    var payUCheckoutProConfig = {
      PayUCheckoutProConfigKeys.primaryColor: "#691A1E",
      PayUCheckoutProConfigKeys.secondaryColor: "#FFFFFF",
      PayUCheckoutProConfigKeys.merchantName: "Fintogo", 
      PayUCheckoutProConfigKeys.merchantLogo: "logo",
      PayUCheckoutProConfigKeys.showExitConfirmationOnCheckoutScreen: false,
      PayUCheckoutProConfigKeys.showExitConfirmationOnPaymentScreen: false,
      PayUCheckoutProConfigKeys.merchantResponseTimeout: 30000,
      PayUCheckoutProConfigKeys.autoSelectOtp: true,
      PayUCheckoutProConfigKeys.enforcePaymentList: enforcePaymentList,
      PayUCheckoutProConfigKeys.waitingTime: 30000,
      PayUCheckoutProConfigKeys.autoApprove: false,
      PayUCheckoutProConfigKeys.merchantSMSPermission: true,
      PayUCheckoutProConfigKeys.showCbToolbar: true,

    };
    return payUCheckoutProConfig;
  }
}




