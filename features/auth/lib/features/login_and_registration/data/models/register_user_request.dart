class RegisterUserRequest {
  String? userFullName;
  String? mobileNumber;
  String? deviceId;
  String? source;
  String? languageCode;
  String? ucic;
  String? superAppId;
  String? logoutSuperAppId;

  RegisterUserRequest(
      {this.userFullName,
        this.mobileNumber,
        this.deviceId,this.source,this.languageCode,this.ucic, this.superAppId, this.logoutSuperAppId
        });

  RegisterUserRequest.fromJson(Map<String, dynamic> json) {
    userFullName = json['userFullName'];
    mobileNumber = json['mobileNumber'];
    deviceId = json['deviceId'];
    source = json['source'];
    languageCode = json['languageCode'];
    ucic = json['ucic'];
    superAppId = json['superAppId'];
    logoutSuperAppId = json['logoutSuperAppId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userFullName'] = userFullName;
    data['mobileNumber'] = mobileNumber;
    data['deviceId'] = deviceId;
    data['source'] = source;
    data['languageCode'] = languageCode;
    data['ucic'] = ucic;
    data['superAppId'] = superAppId;
    data['logoutSuperAppId'] = logoutSuperAppId;
    return data;
  }
}