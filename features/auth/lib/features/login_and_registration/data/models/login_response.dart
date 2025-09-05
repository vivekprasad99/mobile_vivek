
class LoginResponse {
  String? code;
  String? message;
  int? currentAttempt;
  int? maxAttempt;
  String? responseCode;

  LoginResponse({this.code, this.message, this.currentAttempt, this.maxAttempt, this.responseCode});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    currentAttempt = json['currentAttempt'];
    maxAttempt = json['maxAttempt'];
    responseCode = json['responseCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['currentAttempt'] = currentAttempt;
    data['maxAttempt'] = maxAttempt;
    data['responseCode'] = responseCode;
    return data;
  }
}
