import 'dart:convert';

GetTransactionIdRequest getTransactionIdRequestFromJson(String str) =>
    GetTransactionIdRequest.fromJson(json.decode(str));

String getTransactionIdRequestToJson(GetTransactionIdRequest data) =>
    json.encode(data.toJson());

class GetTransactionIdRequest {
  String paymentGateway;
  String loanAccountNumber;
  String sourceSystem;
  String productType;
  String payableAmount;
  String paymentMode;
  String paymentDescriptionUI;
  String source;
  String ucic;
  String deviceId;
  String mobileNumber;
  String merchantId;
  String paymentType;
  String superAppId;
  Map<String, dynamic> pgRequest;

  GetTransactionIdRequest(
      {required this.paymentGateway,
      required this.loanAccountNumber,
      required this.sourceSystem,
      required this.productType,
      required this.payableAmount,
      required this.paymentMode,
      required this.source,
      required this.ucic,
      required this.deviceId,
      required this.mobileNumber,
      required this.merchantId,
      required this.paymentDescriptionUI,
      required this.pgRequest,
      required this.superAppId,
      required this.paymentType});

  factory GetTransactionIdRequest.fromJson(Map<String, dynamic> json) =>
      GetTransactionIdRequest(
          paymentGateway: json["paymentGateway"] ?? '',
          loanAccountNumber: json["loanAccountNumber"] ?? '',
          sourceSystem: json["sourceSystem"] ?? '',
          productType: json["productType"] ?? '',
          payableAmount: json["payableAmount"] ?? '',
          paymentMode: json["paymentMode"] ?? '',
          source: json["source"] ?? '',
          ucic: json["ucic"] ?? '',
          deviceId: json["deviceId"] ?? '',
          mobileNumber: json["mobileNumber"] ?? '',
          merchantId: json["merchantId"] ?? '',
          paymentDescriptionUI: json["paymentDescriptionUI"] ?? '',
          pgRequest: json["pgRequest"] ?? '',
          superAppId: json["superAppId"] ?? '',
          paymentType: json["paymentType"] ?? '');

  Map<String, dynamic> toJson() => {
        "paymentGateway": paymentGateway,
        "loanAccountNumber": loanAccountNumber,
        "sourceSystem": sourceSystem,
        "productType": productType,
        "payableAmount": payableAmount,
        "paymentMode": paymentMode,
        "source": source,
        "ucic": ucic,
        "deviceId": deviceId,
        "mobileNumber": mobileNumber,
        "merchantId": merchantId,
        "superAppId": superAppId,
        "paymentDescriptionUI": paymentDescriptionUI,
        "pgRequest": jsonEncode(pgRequest),
        "paymentType": paymentType
      };
}
