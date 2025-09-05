
class RegisterUserResponse {
  String? code;
  String? message;
  String? superAppId;
  String? responseCode;

  RegisterUserResponse({this.code, this.message, this.superAppId, this.responseCode});

  RegisterUserResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    superAppId = json['superAppId'];
    responseCode = json['responseCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['superAppId'] = superAppId;
    data['responseCode'] = responseCode;
    return data;
  }
}
