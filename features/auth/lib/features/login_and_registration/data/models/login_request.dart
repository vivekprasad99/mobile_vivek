class LoginRequest {
  String? superAppId;
  String? mPin;
  String? source;

  LoginRequest({this.superAppId, this.mPin, this.source});

  LoginRequest.fromJson(Map<String, dynamic> json) {
    superAppId = json['superAppId'];
    mPin = json['mpin'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['superAppId'] = superAppId;
    data['mpin'] = mPin;
    data['source'] = source;
    return data;
  }
}