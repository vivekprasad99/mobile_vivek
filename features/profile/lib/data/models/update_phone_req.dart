class UpdatePhoneReq{
  String? ucic;
  String? mobileNumber;
  String? oldMobileNumber;
  String? consentFlag;
  String? source;
  String? superAppId;
  String? customerName;

  UpdatePhoneReq({this.ucic, this.mobileNumber, this.oldMobileNumber,this.consentFlag, this.source, this.superAppId, this.customerName});

  UpdatePhoneReq.fromJson(Map<String, dynamic> json) {
    ucic = json['ucic'];
    mobileNumber = json['mobileNumber'];
    oldMobileNumber = json['oldMobileNumber'];
    consentFlag = json['consentFlag'];
    source = json['source'];
    superAppId = json['superAppId'];
    customerName = json['customerName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ucic'] = ucic;
    data['mobileNumber'] = mobileNumber;
    data['oldMobileNumber'] = oldMobileNumber;
    data['consentFlag'] = consentFlag;
    data['source'] = source;
    data['superAppId'] = superAppId;
    data['customerName'] = customerName;
    return data;
  }
}