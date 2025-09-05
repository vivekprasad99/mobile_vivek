class AuthenticateSingleUcicRequest {
  String? authNumber;
  String? mobileNumber;
  int? authType;
  String? source;


  AuthenticateSingleUcicRequest(
      {this.authNumber, this.mobileNumber, this.authType, this.source});

  AuthenticateSingleUcicRequest.fromJson(Map<String, dynamic> json) {
    authNumber = json['authNumber'];
    mobileNumber = json['mobileNumber'];
    authType = json['authType'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['authNumber'] = authNumber;
    data['mobileNumber'] = mobileNumber;
    data['authType'] = authType;
    data['source'] = source;
    return data;
  }
}
