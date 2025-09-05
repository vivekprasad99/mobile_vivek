class AddressUpdateOfflineRequest {
  String? ucic;
  String? source;
  String? superAppId;
  bool? consentFlag;
  bool? sameAsMainAddress;
  String? postOfficeName;
  String? addrType;
  String? state;
  String? city;
  String? country;
  String? pinCode;
  String? combinedAddress;
  String? documentId;
  String? customerName;

  AddressUpdateOfflineRequest(
      {this.ucic,
      this.source,
      this.superAppId,
      this.consentFlag,
      this.sameAsMainAddress,
      this.postOfficeName,
      this.addrType,
      this.state,
      this.city,
      this.country,
      this.pinCode,
      this.combinedAddress,
      this.documentId, this.customerName});

  AddressUpdateOfflineRequest.fromJson(Map<String, dynamic> json) {
    ucic = json['ucic'];
    source = json['source'];
    superAppId = json['superAppId'];
    consentFlag = json['consentFlag'];
    sameAsMainAddress = json['sameAsMainAddress'];
    postOfficeName = json['postOfficeName'];
    addrType = json['addrType'];
    state = json['state'];
    city = json['city'];
    country = json['country'];
    pinCode = json['pinCode'];
    combinedAddress = json['combinedAddress'];
    documentId = json['documentId'];
    customerName = json['customerName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ucic'] = ucic;
    data['source'] = source;
    data['superAppId'] = superAppId;
    data['consentFlag'] = consentFlag;
    data['sameAsMainAddress'] = sameAsMainAddress;
    data['postOfficeName'] = postOfficeName;
    data['addrType'] = addrType;
    data['state'] = state;
    data['city'] = city;
    data['country'] = country;
    data['pinCode'] = pinCode;
    data['combinedAddress'] = combinedAddress;
    data['documentId'] = documentId;
    data['customerName'] = customerName;
    return data;
  }
}
