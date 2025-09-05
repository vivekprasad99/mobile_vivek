class ValidateEmailOtpRequest {
  String? email;
  String? journey;
  String? source;
  String? otp;
  String? superAppId;

  ValidateEmailOtpRequest(
      {this.email, this.journey, this.source, this.otp, this.superAppId});

  ValidateEmailOtpRequest.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    journey = json['journey'];
    source = json['source'];
    otp = json['otp'];
    superAppId = json['superAppId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['journey'] = journey;
    data['source'] = source;
    data['otp'] = otp;
    data['superAppId'] = superAppId;
    return data;
  }
}
