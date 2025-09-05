import 'package:equatable/equatable.dart';

class PopularBankListRes {
  String? status;
  String? message;
  Data? data;
  String? responseCode;

  PopularBankListRes({this.status, this.message, this.responseCode, this.data});


  PopularBankListRes.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    responseCode = json['responseCode'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
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
  List<PopularBank>? banks;

  Data({this.source, this.banks});

  Data.fromJson(Map<String, dynamic> json) {
    source = json['source'];
    if (json['banks'] != null) {
      banks = <PopularBank>[];
      json['banks'].forEach((v) {
        banks!.add(PopularBank.fromJson(v));
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
// ignore_for_file: must_be_immutable
class PopularBank extends Equatable {
  int? bankId;
  String? bankName;
  String? bankCode;
  bool? isPopular = true;

  PopularBank({
    this.bankId,
    this.bankName,
    this.bankCode,
    this.isPopular,
  });

  factory PopularBank.fromJson(Map<String, dynamic> json) => PopularBank(
    bankId: json["bankId"] ?? 0,
    bankName: json["bankName"],
    bankCode: json["bank_code"],
    isPopular: json["is_popular"]
  );

  Map<String, dynamic> toJson() => {
    "bankId": bankId,
    "bankName": bankName,
    "bank_code": bankCode,
    "is_popular": isPopular
  };

  @override
  List<Object?> get props => [bankId, bankName, bankCode];
}