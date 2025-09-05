class MPinResponse {
  String? code;
  String? message;
  int? currentAttempt;
  int? maxAttempt;

  MPinResponse({this.code, this.message});

  MPinResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    currentAttempt = json['currentAttempts'];
    maxAttempt = json['maxAttempts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['currentAttempts'] = currentAttempt;
    data['maxAttempts'] = maxAttempt;
    return data;
  }
}
