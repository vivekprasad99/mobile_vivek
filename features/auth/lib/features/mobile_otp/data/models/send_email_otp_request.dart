class SendEmailOtpRequest {
  String? email;
  String? journey;
  String? source;
  String? superAppId;

  SendEmailOtpRequest(
      {this.email, this.journey, this.source, this.superAppId});

  SendEmailOtpRequest.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    journey = json['journey'];
    source = json['source'];
    superAppId = json['superAppId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['journey'] = journey;
    data['source'] = source;
    data['superAppId'] = superAppId;
    return data;
  }
}
