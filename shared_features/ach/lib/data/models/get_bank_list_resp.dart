import 'package:equatable/equatable.dart';
// ignore_for_file: must_be_immutable
class GetBankListResponse {
  String? code;
  String? message;
  String? responseCode;
  Data? data;

  GetBankListResponse({this.code, this.message, this.responseCode, this.data});

  GetBankListResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    responseCode = json['responseCode'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
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
  List<Bank>? banks;

  Data({this.source, this.banks});

  Data.fromJson(Map<String, dynamic> json) {
    source = json['source'];
    if (json['banks'] != null) {
      banks = <Bank>[];
      json['banks'].forEach((v) {
        banks!.add(Bank.fromJson(v));
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

class Bank extends Equatable {
  int? bankId;
  String? bankName;
  String? bankCode;
  bool? isPopular;
  List<VerificationOption>? verificationOption;

   Bank({
    this.bankId,
    this.bankName,
    this.bankCode,
    this.isPopular,
    this.verificationOption,
  });

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        bankId: json["bankId"],
        bankName: json["bankName"],
        bankCode: json["bankCode"],
        isPopular: json["is_popular"],
        verificationOption: json["mode"] == null
            ? []
            : List<VerificationOption>.from(json["mode"]!
                .map((x) => VerificationOption.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "bankId": bankId,
        "bankName": bankName,
        "bankCode": bankCode,
        "is_popular": isPopular,
        "mode": verificationOption == null
            ? []
            : List<dynamic>.from(verificationOption!.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [bankId, bankName, bankCode, verificationOption];
}

class VerificationOption extends Equatable {
  String? optionId;
  String? optionName;
  bool? isRecommended;

  VerificationOption({
    this.optionId,
    this.optionName,
    this.isRecommended,
  });

  factory VerificationOption.fromJson(Map<String, dynamic> json) =>
      VerificationOption(
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
