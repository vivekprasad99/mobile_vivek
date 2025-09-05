class OtpScreenExtrasModel {
  String? otpScreenType;
  String? mobileNumber;
  String? emailId;

  OtpScreenExtrasModel({this.otpScreenType, this.mobileNumber, this.emailId});

  OtpScreenExtrasModel.fromJson(Map<String, dynamic> json) {
    otpScreenType = json['otpScreenType'];
    mobileNumber = json['mobileNumber'];
    emailId = json['emailId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['otpScreenType'] = otpScreenType;
    data['mobileNumber'] = mobileNumber;
    data['emailId'] = emailId;
    return data;
  }
}
