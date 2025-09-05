import 'package:equatable/equatable.dart';

class GetCMSBankListResponse {
   String? statusCode;
   String? message;
   Data? data;
   String? responseCode;

  GetCMSBankListResponse({this.statusCode, this.message, this.responseCode, this.data});


  GetCMSBankListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['status'];
    message = json['message'];
    responseCode = json['responseCode'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['responseCode'] = responseCode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? source;
  List<CMSBank>? banks;

  Data({this.source, this.banks});

  Data.fromJson(Map<String, dynamic> json) {
    source = json['source'];
    if (json['banks'] != null) {
      banks = <CMSBank>[];
      json['banks'].forEach((v) {
        banks!.add(CMSBank.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['source'] = source;
    if (banks != null) {
      data['banks'] = banks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CMSBank extends Equatable {
  int? bankId;
  String? bankName;
  String? bankCode;
  bool? isPopular = true;
  List<CMSVerificationOption>? verificationOption;

  CMSBank({
    this.bankId,
    this.bankName,
    this.bankCode,
    this.isPopular,
    this.verificationOption,
  });

  factory CMSBank.fromJson(Map<String, dynamic> json) => CMSBank(
        bankId: json["bankId"] ?? 0,
        bankName: json["bankName"],
        bankCode: json["bank_code"],
        isPopular: json["is_popular"],
        verificationOption: json["verification_option"] == null
            ? []
            : List<CMSVerificationOption>.from(json["verification_option"]!
                .map((x) => CMSVerificationOption.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "bankId": bankId,
        "bankName": bankName,
        "bank_code": bankCode,
        "is_popular": isPopular,
        "verification_option": verificationOption == null
            ? []
            : List<dynamic>.from(verificationOption!.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [bankId, bankName, bankCode, verificationOption];
}
// ignore_for_file: must_be_immutable
class CMSVerificationOption extends Equatable {
  String? optionId;
  String? optionName;
  final bool? isRecommended;

  CMSVerificationOption({
    this.optionId,
    this.optionName,
    this.isRecommended,
  });

  factory CMSVerificationOption.fromJson(Map<String, dynamic> json) =>
      CMSVerificationOption(
        optionId: json["option_id"],
        optionName: json["option_name"],
        isRecommended: json["is_recommended"],
      );

  Map<String, dynamic> toJson() =>
      {
        "option_id": optionId,
        "option_name": optionName,
        "is_recommended": isRecommended,
      };

  @override
  List<Object?> get props => [optionId, optionName, isRecommended];
}
