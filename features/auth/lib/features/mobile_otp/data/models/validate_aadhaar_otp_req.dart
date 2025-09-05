class ValidateAadhaarOtpReq {
  String? source;
  String? superAppId;
  String? aadhaarNo;
  String? userOtp;
  String? transactionId;

  ValidateAadhaarOtpReq(
      {this.source,
      this.superAppId,
      this.aadhaarNo,
      this.userOtp,
      this.transactionId});

  ValidateAadhaarOtpReq.fromJson(Map<String, dynamic> json) {
    source = json['source'];
    superAppId = json['superAppId'];
    aadhaarNo = json['aadhaarNo'];
    userOtp = json['userOtp'];
    transactionId = json['transactionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['source'] = source;
    data['superAppId'] = superAppId;
    data['aadhaarNo'] = aadhaarNo;
    data['userOtp'] = userOtp;
    data['transactionId'] = transactionId;
    return data;
  }
}
