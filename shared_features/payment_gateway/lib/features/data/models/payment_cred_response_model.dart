
import 'dart:convert';

PaymentCredentialsResponseModel paymentCredentialsResponseModelFromJson(String str) => PaymentCredentialsResponseModel.fromJson(json.decode(str));

String paymentCredentialsResponseModelToJson(PaymentCredentialsResponseModel data) => json.encode(data.toJson());

class PaymentCredentialsResponseModel {
    String code;
    String message;
    String responseCode;
    CamsPay camsPay;
    Payu payu;

    PaymentCredentialsResponseModel({
        required this.code,
        required this.message,
        required this.responseCode,
        required this.camsPay,
        required this.payu,
    });

    factory PaymentCredentialsResponseModel.fromJson(Map<String, dynamic> json) => PaymentCredentialsResponseModel(
        code: json["code"],
        message: json["message"],
        responseCode: json["responseCode"],
        camsPay: CamsPay.fromJson(json["camsPay"]),
        payu: Payu.fromJson(json["payu"]),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "responseCode": responseCode,
        "camsPay": camsPay.toJson(),
        "payu": payu.toJson(),
    };
}

class CamsPay {
    CamsPayFixedDeposit personalLoan;
    CamsPayFixedDeposit vehicleLoan;
    CamsPayFixedDeposit fixedDeposit;

    CamsPay({
        required this.personalLoan,
        required this.vehicleLoan,
        required this.fixedDeposit,
    });

    factory CamsPay.fromJson(Map<String, dynamic> json) => CamsPay(
        personalLoan: CamsPayFixedDeposit.fromJson(json["personalLoan"]),
        vehicleLoan: CamsPayFixedDeposit.fromJson(json["vehicleLoan"]),
        fixedDeposit: CamsPayFixedDeposit.fromJson(json["fixedDeposit"]),
    );

    Map<String, dynamic> toJson() => {
        "personalLoan": personalLoan.toJson(),
        "vehicleLoan": vehicleLoan.toJson(),
        "fixedDeposit": fixedDeposit.toJson(),
    };
}

class CamsPayFixedDeposit {
    String merchantId;
    String subBillerId;
    String checkSumKey;
    String idEncryptionKey;
    String idEncryptingIv;
    String reqEncryptionKey;
    String reqEncryptionIv;

    CamsPayFixedDeposit({
        required this.merchantId,
        required this.subBillerId,
        required this.checkSumKey,
        required this.idEncryptionKey,
        required this.idEncryptingIv,
        required this.reqEncryptionKey,
        required this.reqEncryptionIv,
    });

    factory CamsPayFixedDeposit.fromJson(Map<String, dynamic> json) => CamsPayFixedDeposit(
        merchantId: json["merchantId"],
        subBillerId: json["subBillerId"],
        checkSumKey: json["checkSumKey"],
        idEncryptionKey: json["idEncryptionKey"],
        idEncryptingIv: json["idEncryptingIV"],
        reqEncryptionKey: json["reqEncryptionKEY"],
        reqEncryptionIv: json["reqEncryptionIV"],
    );

    Map<String, dynamic> toJson() => {
        "merchantId": merchantId,
        "subBillerId": subBillerId,
        "checkSumKey": checkSumKey,
        "idEncryptionKey": idEncryptionKey,
        "idEncryptingIV": idEncryptingIv,
        "reqEncryptionKEY": reqEncryptionKey,
        "reqEncryptionIV": reqEncryptionIv,
    };
}

class Payu {
    PayuFixedDeposit personalLoan;
    PayuFixedDeposit vehicleLoan;
    PayuFixedDeposit fixedDeposit;
    PayuConstant payuConstant;

    Payu({
        required this.personalLoan,
        required this.vehicleLoan,
        required this.fixedDeposit,
        required this.payuConstant,
    });

    factory Payu.fromJson(Map<String, dynamic> json) => Payu(
        personalLoan: PayuFixedDeposit.fromJson(json["personalLoan"]),
        vehicleLoan: PayuFixedDeposit.fromJson(json["vehicleLoan"]),
        fixedDeposit: PayuFixedDeposit.fromJson(json["fixedDeposit"]),
        payuConstant: PayuConstant.fromJson(json["payuConstant"]),
    );

    Map<String, dynamic> toJson() => {
        "personalLoan": personalLoan.toJson(),
        "vehicleLoan": vehicleLoan.toJson(),
        "fixedDeposit": fixedDeposit.toJson(),
        "payuConstant": payuConstant.toJson(),
    };
}

class PayuFixedDeposit {
    String merchantId;
    String hashToken;

    PayuFixedDeposit({
        required this.merchantId,
        required this.hashToken,
    });

    factory PayuFixedDeposit.fromJson(Map<String, dynamic> json) => PayuFixedDeposit(
        merchantId: json["merchantId"],
        hashToken: json["hashToken"],
    );

    Map<String, dynamic> toJson() => {
        "merchantId": merchantId,
        "hashToken": hashToken,
    };
}

class PayuConstant {
    String iosFurl;
    String androidSurl;
    String androidFurl;
    String iosSurl;

    PayuConstant({
        required this.iosFurl,
        required this.androidSurl,
        required this.androidFurl,
        required this.iosSurl,
    });

    factory PayuConstant.fromJson(Map<String, dynamic> json) => PayuConstant(
        iosFurl: json["iosFurl"],
        androidSurl: json["androidSurl"],
        androidFurl: json["androidFurl "],
        iosSurl: json["iosSurl"],
    );

    Map<String, dynamic> toJson() => {
        "iosFurl": iosFurl,
        "androidSurl": androidSurl,
        "androidFurl ": androidFurl,
        "iosSurl": iosSurl,
    };
}
