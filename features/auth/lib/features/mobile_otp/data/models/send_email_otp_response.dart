class SendEmailOtpResponse {
  String? code;
  String? message;
  String? responseCode;

  SendEmailOtpResponse({this.responseCode, this.code, this.message});

  SendEmailOtpResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responseCode'] = responseCode;
    data['code'] = code;
    data['message'] = message;
    return data;
  }
}
