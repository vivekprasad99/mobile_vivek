class AadhaarConsentRes {
  String? code;
  String? message;
  String? responseCode;
  double? matchScore;
  String? transactionId;

  AadhaarConsentRes(
      {this.code,
      this.message,
      this.responseCode,
      this.matchScore,
      this.transactionId});

  AadhaarConsentRes.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    responseCode = json['responseCode'];
    matchScore = json['matchScore'];
    transactionId = json['transactionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['responseCode'] = responseCode;
    data['matchScore'] = matchScore;
    data['transactionId'] = transactionId;
    return data;
  }
}
