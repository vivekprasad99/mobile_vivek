class PennyDropResponse {
  String? code;
  String? message;
  String? responseCode;
  PennyDropDetail? pennyDropDetail;

  PennyDropResponse({this.code, this.message, this.responseCode, this.pennyDropDetail});

  PennyDropResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    responseCode = json['responseCode'];
    pennyDropDetail = json['data'] != null ? PennyDropDetail.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['responseCode'] = responseCode;
    if (pennyDropDetail != null) {
      data['data'] = pennyDropDetail!.toJson();
    }
    return data;
  }
}

class PennyDropDetail {
  String? statusCode;
  String? message;
  double? score;
  String? beneficiaryName;
  String? accountStatus;
  bool? pennyDropSuccess;
  bool? nameMatchSuccess;

  PennyDropDetail(
      {this.statusCode,
        this.message,
        this.score,
        this.beneficiaryName,
        this.accountStatus,
        this.pennyDropSuccess,
        this.nameMatchSuccess});

  PennyDropDetail.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    message = json['message'];
    score = json['score'];
    beneficiaryName = json['beneficiaryName'];
    accountStatus = json['accountStatus'];
    pennyDropSuccess = json['pennyDropSuccess'];
    nameMatchSuccess = json['nameMatchSuccess'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StatusCode'] = statusCode;
    data['message'] = message;
    data['score'] = score;
    data['beneficiaryName'] = beneficiaryName;
    data['accountStatus'] = accountStatus;
    data['pennyDropSuccess'] = pennyDropSuccess;
    data['nameMatchSuccess'] = nameMatchSuccess;
    return data;
  }
}
