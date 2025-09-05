class SendOtpRequest {
  String? mobileNumber;
  int? tncFlag;
  bool? otpResend;
  String? source;
  String? journey;
  String? superAppId;


  SendOtpRequest({this.mobileNumber, this.tncFlag, this.otpResend, this.source, this.journey, this.superAppId});

  SendOtpRequest.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['mobileNumber'];
    tncFlag = json['tncFlag'];
    otpResend = json['otpResend'];
    source = json['source'];
    journey = json['journey'];
    superAppId = json['superAppId'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobileNumber'] = mobileNumber;
    data['tncFlag'] = tncFlag;
    data['otpResend'] = otpResend;
    data['source'] = source;
    data['journey'] = journey;
    data['superAppId'] = superAppId;
    return data;
  }
}