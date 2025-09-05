class ValidateEmailOtpResponse {
  String? code;
  String? message;
  String? responseCode;

  ValidateEmailOtpResponse({this.code, this.message,this.responseCode});

  ValidateEmailOtpResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    responseCode = json['responseCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['responseCode'] = responseCode;
    return data;
  }
}