import 'package:equatable/equatable.dart';


class FetchBankAccountResponse extends Equatable {
  final String? code;
  final List<BankData>? data;
  final String? message;
  final String? responseCode;

  const FetchBankAccountResponse({
    this.code,
    this.data,
    this.message,
    this.responseCode,
  });

  factory FetchBankAccountResponse.fromJson(Map<String, dynamic> json) =>
      FetchBankAccountResponse(
        code: json["code"],
        data: json["data"] == null
            ? []
            : List<BankData>.from(
                json["data"]!.map((x) => BankData.fromJson(x))),
        message: json["message"],
        responseCode: json["responseCode"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
        "responseCode": responseCode,
      };

  @override
  List<Object?> get props => [code, data, message];
}

class BankData extends Equatable {
  final String? bankCode;
  final String? bankName;
  final String? bankAccountNo;
  final String? accountType;
  final String? ifscCode;

  const BankData({
    this.bankCode,
    this.bankName,
    this.bankAccountNo,
    this.accountType,
    this.ifscCode,
  });

  factory BankData.fromJson(Map<String, dynamic> json) => BankData(
        bankCode: json["bankCode"],
        bankName: json["bankName"],
        bankAccountNo: json["accountNumber"],
        accountType: json["accountType"],
        ifscCode: json["ifscCode"]
      );

  Map<String, dynamic> toJson() => {
        "bankCode": bankCode,
        "bankName": bankName,
        "accountNumber": bankAccountNo,
        "accountType": accountType,
        "ifscCode": ifscCode,
      };

  @override
  List<Object?> get props => [
        bankCode,
        bankName,
        bankAccountNo,
        accountType,
        ifscCode,
      ];
}

// class VerificationOption extends Equatable {
//   final String? optionId;
//   final String? optionName;
//   final String? optionAccNo;
//   final bool? isRecommended;
//
//   const VerificationOption({
//     this.optionId,
//     this.optionName,
//     this.optionAccNo,
//     this.isRecommended,
//   });
//
//   factory VerificationOption.fromJson(Map<String, dynamic> json) =>
//       VerificationOption(
//         optionId: json["option_id"],
//         optionName: json["option_name"],
//         optionAccNo: json["options_acc_no"],
//         isRecommended: json["is_recommended"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "option_id": optionId,
//         "option_name": optionName,
//         "options_acc_no": optionAccNo,
//         "is_recommended": isRecommended,
//       };
//
//   @override
//   List<Object?> get props => [
//         optionId,
//         optionName,
//         optionAccNo,
//         isRecommended,
//       ];
// }
