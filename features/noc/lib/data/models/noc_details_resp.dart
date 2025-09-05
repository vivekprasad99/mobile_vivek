// ignore_for_file: public_member_api_docs, sort_constructors_first
class NocDetailsResponse {
  final String? code;
  final String? message;
  final NocData? data;
  final String? responseCode;

  NocDetailsResponse({
    this.code,
    this.message,
    this.data,
    this.responseCode,
  });

  factory NocDetailsResponse.fromJson(Map<String, dynamic> json) =>
      NocDetailsResponse(
        code: json["code"],
        message: json["message"],
        data: json["data"] == null ? null : NocData.fromJson(json["data"]),
        responseCode: json['responseCode'],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data?.toJson(),
        "responseCode": responseCode,
      };

  NocDetailsResponse copyWith(
      {String? code, String? message, NocData? data, String? responseCode}) {
    return NocDetailsResponse(
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
      responseCode: responseCode ?? this.responseCode,
    );
  }
}

class NocData {
  final String? ucic;
  final String? loanAccountNumber;
  final String? productCategory;
  final String? productName;
  final String? registrationNo;
  final String? endDate;
  final String? model;
  final String? nocStatus;
  final String? deliveryLocation;
  final String? branchName;
  final String? branchLocation;
  final String? handoverTo;
  final String? handoverDate;
  final String? handoverToName;
  final String? mobileNumber;
  final String? lob;
  final String? customerNo;
  final String? chasisNo;
  final String? vehicleEngineNo;
  final String? financersName;
  final String? sourceSystem;
  final String? netSettlementAmt;
  final String? displayNocStatus;
  final bool? isEngineMatched;
  final bool? isChassisMatched;
  final bool? isCustNameMatched;
  final bool? isFinancerMatched;

  NocData({
    this.ucic,
    this.loanAccountNumber,
    this.productCategory,
    this.productName,
    this.registrationNo,
    this.endDate,
    this.model,
    this.nocStatus,
    this.deliveryLocation,
    this.branchName,
    this.branchLocation,
    this.handoverTo,
    this.handoverDate,
    this.handoverToName,
    this.customerNo,
    this.chasisNo,
    this.vehicleEngineNo,
    this.financersName,
    this.mobileNumber,
    this.lob,
    this.sourceSystem,
    this.netSettlementAmt,
    this.displayNocStatus,
    this.isEngineMatched,
    this.isChassisMatched,
    this.isCustNameMatched,
    this.isFinancerMatched,
  });

  factory NocData.fromJson(Map<String, dynamic> json) => NocData(
        ucic: json["ucic"],
        loanAccountNumber: json["loanAccountNumber"],
        productCategory: json["productCategory"],
        productName: json["productName"],
        registrationNo: json["registrationNo"],
        endDate: json["endDate"],
        model: json["model"],
        nocStatus: json["nocStatus"],
        deliveryLocation: json["deliveryLocation"],
        branchName: json["branchName"],
        branchLocation: json["branchLocation"],
        handoverTo: json["handoverTo"],
        handoverDate: json["handoverDate"],
        handoverToName: json["handoverToName"],
        customerNo: json["customer_no"],
        chasisNo: json["chasis_no"],
        vehicleEngineNo: json["vehicle_engine_no"],
        financersName: json["financers_name"],
        mobileNumber: json['mobileNumber'],
        lob: json['lob'],
        sourceSystem: json['sourceSystem'],
        netSettlementAmt: json["netSettlementAmt"],
        displayNocStatus: json['displayNocStatus'],
        isEngineMatched: json["isEngineMatched"],
        isChassisMatched: json["isChassisMatched"],
        isCustNameMatched: json["isCustNameMatched"],
        isFinancerMatched: json["isFinancerMatched"],
      );

  Map<String, dynamic> toJson() => {
        "ucic": ucic,
        "loanAccountNumber": loanAccountNumber,
        "productCategory": productCategory,
        "productName": productName,
        "registrationNo": registrationNo,
        "endDate": endDate,
        "model": model,
        "nocStatus": nocStatus,
        "deliveryLocation": deliveryLocation,
        "branchName": branchName,
        "branchLocation": branchLocation,
        "handoverTo": handoverTo,
        "handoverDate": handoverDate,
        "handoverToName": handoverToName,
        "customer_no": customerNo,
        "chasis_no": chasisNo,
        "vehicle_engine_no": vehicleEngineNo,
        "financers_name": financersName,
        "mobileNumber": mobileNumber,
        "lob": lob,
        "sourceSystem": sourceSystem,
        "netSettlementAmt": netSettlementAmt,
        "displayNocStatus": displayNocStatus,
        "isEngineMatched": isEngineMatched,
        "isChassisMatched": isChassisMatched,
        "isCustNameMatched": isCustNameMatched,
        "isFinancerMatched": isFinancerMatched,
      };

  NocData copyWith({
    String? ucic,
    String? loanAccountNumber,
    String? productCategory,
    String? productName,
    String? registrationNo,
    String? endDate,
    String? model,
    String? nocStatus,
    String? deliveryLocation,
    String? branchName,
    String? branchLocation,
    String? handoverTo,
    String? handoverDate,
    String? handoverToName,
    String? mobileNumber,
    String? lob,
    String? customerNo,
    String? chasisNo,
    String? vehicleEngineNo,
    String? financersName,
    String? sourceSystem,
    String? netSettlementAmt,
    String? displayNocStatus,
    bool? isEngineMatched,
    bool? isChassisMatched,
    bool? isCustNameMatched,
    bool? isFinancerMatched,
  }) {
    return NocData(
      ucic: ucic ?? this.ucic,
      loanAccountNumber: loanAccountNumber ?? this.loanAccountNumber,
      productCategory: productCategory ?? this.productCategory,
      productName: productName ?? this.productName,
      registrationNo: registrationNo ?? this.registrationNo,
      endDate: endDate ?? this.endDate,
      model: model ?? this.model,
      nocStatus: nocStatus ?? this.nocStatus,
      deliveryLocation: deliveryLocation ?? this.deliveryLocation,
      branchName: branchName ?? this.branchName,
      branchLocation: branchLocation ?? this.branchLocation,
      handoverTo: handoverTo ?? this.handoverTo,
      handoverDate: handoverDate ?? this.handoverDate,
      handoverToName: handoverToName ?? this.handoverToName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      lob: lob ?? this.lob,
      customerNo: customerNo ?? this.customerNo,
      chasisNo: chasisNo ?? this.chasisNo,
      vehicleEngineNo: vehicleEngineNo ?? this.vehicleEngineNo,
      financersName: financersName ?? this.financersName,
      sourceSystem: sourceSystem ?? this.sourceSystem,
      netSettlementAmt: netSettlementAmt ?? this.netSettlementAmt,
      displayNocStatus: displayNocStatus ?? this.displayNocStatus,
      isEngineMatched: isEngineMatched ?? this.isEngineMatched,
      isChassisMatched: isChassisMatched ?? this.isChassisMatched,
      isCustNameMatched: isCustNameMatched ?? this.isCustNameMatched,
      isFinancerMatched: isFinancerMatched ?? this.isFinancerMatched,
    );
  }
}
