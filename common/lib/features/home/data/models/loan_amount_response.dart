class LoanAmountResponse {
  final String? code;
  final String? message;
  final String? responseCode;
  final Data? data;
  const LoanAmountResponse(
      {this.code, this.message, this.responseCode, this.data,});
  LoanAmountResponse copyWith(
      {String? code, String? message, String? responseCode, Data? data,}) {
    return LoanAmountResponse(
        code: code ?? this.code,
        message: message ?? this.message,
        responseCode: responseCode ?? this.responseCode,
        data: data ?? this.data,);
  }

  Map<String, Object?> toJson() {
    return {
      'code': code,
      'message': message,
      'responseCode': responseCode,
      'Data': data?.toJson(),
    };
  }

  static LoanAmountResponse fromJson(Map<String, Object?> json) {
    return LoanAmountResponse(
        code: json['code'] == null ? null : json['code'] as String,
        message: json['message'] == null ? null : json['message'] as String,
        responseCode: json['responseCode'] == null
            ? null
            : json['responseCode'] as String,
        data: json['Data'] == null
            ? null
            : Data.fromJson(json['Data'] as Map<String, Object?>),);
  }

  @override
  String toString() {
    return '''LoanAmountResponse(
                code:$code,
message:$message,
responseCode:$responseCode,
Data:${data.toString()}
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is LoanAmountResponse &&
        other.runtimeType == runtimeType &&
        other.code == code &&
        other.message == message &&
        other.responseCode == responseCode &&
        other.data == data;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, code, message, responseCode, data);
  }
}

class Data {
  final String? loanAmount;
  const Data({this.loanAmount});
  Data copyWith({String? loanAmount}) {
    return Data(loanAmount: loanAmount ?? this.loanAmount);
  }

  Map<String, Object?> toJson() {
    return {'loanAmount': loanAmount};
  }

  static Data fromJson(Map<String, Object?> json) {
    return Data(
        loanAmount:
            json['loanAmount'] == null ? null : json['loanAmount'] as String,);
  }

  @override
  String toString() {
    return '''Data(
                loanAmount:$loanAmount
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is Data &&
        other.runtimeType == runtimeType &&
        other.loanAmount == loanAmount;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, loanAmount);
  }
}
