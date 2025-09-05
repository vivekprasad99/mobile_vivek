class ValidateOtpResponse {
  String? code;
  String? message;
  int? currentAttempts;
  String? responseCode;

  ValidateOtpResponse({this.code, this.message,this.currentAttempts, this.responseCode});

  ValidateOtpResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    currentAttempts = json['currentAttempts'];
    responseCode = json['responseCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['currentAttempts'] = currentAttempts;
    data['responseCode'] = responseCode;
    return data;
  }
}