// To parse this JSON data, do
//
//     final getLoanDetailsResponse = getLoanDetailsResponseFromJson(jsonString);

import 'dart:convert';

GetLoanDetailsResponse getLoanDetailsResponseFromJson(String str) =>
    GetLoanDetailsResponse.fromJson(json.decode(str));

String getLoanDetailsResponseToJson(GetLoanDetailsResponse data) =>
    json.encode(data.toJson());

class GetLoanDetailsResponse {
  final String? status;
  final String? message;
  final LoanDetails? data;

  GetLoanDetailsResponse({
    this.status,
    this.message,
    this.data,
  });

  factory GetLoanDetailsResponse.fromJson(Map<String, dynamic> json) =>
      GetLoanDetailsResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : LoanDetails.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class LoanDetails {
  final String? ucic;
  final String? loanNumber;
  final String? totalPendingAmount;
  final String? totalAmount;
  final bool? isServiceRequestExist;
  final String? serviceRequestStatus;
  final bool? isLockingPeriod;
  final bool? isFreezePeriod;
  final String? lockingPeriodEndDate;
  final String? sourceSystem;
  final String? productCategory;
  final bool? isRuleOnePassed;
  String? cif;
  String? lob;
  String? productName;
  String? mobileNumber;

  LoanDetails(
      {this.ucic,
      this.loanNumber,
      this.totalPendingAmount,
      this.totalAmount,
      this.isServiceRequestExist,
      this.serviceRequestStatus,
      this.isLockingPeriod,
      this.isFreezePeriod,
      this.lockingPeriodEndDate,
      this.sourceSystem,
      this.productCategory,
      this.isRuleOnePassed,
      this.lob,
      this.productName,
      this.mobileNumber,
      this.cif});

  factory LoanDetails.fromJson(Map<String, dynamic> json) => LoanDetails(
      ucic: json["ucic"],
      loanNumber: json["loanNumber"] ?? '',
      totalPendingAmount: json["totalPendingAmount"].toString(),
      totalAmount: json["totalAmount"].toString(),
      isServiceRequestExist: json["serviceRequestExist"],
      serviceRequestStatus: json["serviceRequestStatus"],
      isLockingPeriod: json["lockingPeriodExists"],
      isFreezePeriod: json["freezePeriodExists"],
      lockingPeriodEndDate: json["lockingPeriodEndDate"],
      sourceSystem: json["sourceSystem"],
      productCategory: json["productCategory"],
      isRuleOnePassed: json["ruleOnePassed"],
  );

  Map<String, dynamic> toJson() => {
        "ucic": ucic,
        "loanNumber": loanNumber,
        "totalPendingAmount": totalPendingAmount,
        "totalAmount": totalAmount,
        "isServiceRequestExist": isServiceRequestExist,
        "serviceRequestStatus": serviceRequestStatus,
        "isLockingPeriod": isLockingPeriod,
        "isFreezePeriod": isFreezePeriod,
        "lockingPeriodEndDate": lockingPeriodEndDate,
        "sourceSystem": sourceSystem,
        "productCategory": productCategory,
        "isRuleOnePassed": isRuleOnePassed,
      };
}
