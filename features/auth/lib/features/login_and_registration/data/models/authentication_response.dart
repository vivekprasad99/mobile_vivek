class AuthenticationResponse {
  String? code;
  String? message;
  String? userFullName;
  String? ucic;
  bool? uniqueUcicFound;
  String? responseCode;
  String? lanAsPerDataLake;
  String? panAsPerDataLake;

  AuthenticationResponse({this.code, this.message,this.userFullName, this.ucic, this.uniqueUcicFound, this.responseCode, this.lanAsPerDataLake, this.panAsPerDataLake});

  AuthenticationResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    userFullName = json['userFullName'];
    ucic = json['ucic'];
    uniqueUcicFound = json['uniqueUcicFound'];
    responseCode = json['responseCode'];
    lanAsPerDataLake = json['lanAsPerDataLake'];
    panAsPerDataLake = json['panAsPerDataLake'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['userFullName'] = userFullName;
    data['uniqueUcicFound'] = uniqueUcicFound;
    data['ucic'] = ucic;
    data['responseCode'] = responseCode;
    data['lanAsPerDataLake'] = lanAsPerDataLake;
    data['panAsPerDataLake'] = panAsPerDataLake;
    return data;
  }
}