class AadhaarConsentReq {
  String? source;
  String? superAppId;
  String? purpose;
  String? userIpAddress;
  String? aadhaarNo;
  String? userLatitude;
  String? userLongitude;
  String? userAgent;
  String? userName;

  AadhaarConsentReq(
      {this.source,
      this.superAppId,
      this.purpose,
      this.userIpAddress,
      this.aadhaarNo,
      this.userLatitude,
      this.userLongitude,
      this.userAgent,
      this.userName});

  AadhaarConsentReq.fromJson(Map<String, dynamic> json) {
    source = json['source'];
    superAppId = json['superAppId'];
    purpose = json['purpose'];
    userIpAddress = json['userIpAddress'];
    aadhaarNo = json['aadhaarNo'];
    userLatitude = json['userLatitude'];
    userLongitude = json['userLongitude'];
    userAgent = json['userAgent'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['source'] = source;
    data['superAppId'] = superAppId;
    data['purpose'] = purpose;
    data['userIpAddress'] = userIpAddress;
    data['aadhaarNo'] = aadhaarNo;
    data['userLatitude'] = userLatitude;
    data['userLongitude'] = userLongitude;
    data['userAgent'] = userAgent;
    data['userName'] = userName;
    return data;
  }
}
