class ValidateOtpRequest {
  String? otp;
  String? mobileNumber;
  int? tNCFlag;
  String? source;
  String? journey;

  ValidateOtpRequest({this.otp, this.mobileNumber,this.tNCFlag, this.source, this.journey});

  ValidateOtpRequest.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    mobileNumber = json['mobileNumber'];
    tNCFlag = json['tncFlag'];
    source = json['source'];
    journey = json['journey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['otp'] = otp;
    data['mobileNumber'] = mobileNumber;
    data['tncFlag'] = tNCFlag;
    data['source'] = source;
    data['journey'] = journey;
    return data;
  }
}