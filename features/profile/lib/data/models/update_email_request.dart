class UpdateEmailRequest {
  String? ucic;
  String? emailId;
  String? oldEmailId;
  String? consentFlag;
  String? superAppId;
  String? source;
  String? customerName;

  UpdateEmailRequest({this.ucic, this.emailId, this.oldEmailId, this.consentFlag, this.superAppId, this.source, this.customerName});

  UpdateEmailRequest.fromJson(Map<String, dynamic> json) {
    ucic = json['ucic'];
    emailId = json['emailId'];
    oldEmailId = json['oldEmailId'];
    consentFlag = json['consentFlag'];
    superAppId = json['superAppId'];
    source = json['source'];
    customerName = json['customerName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ucic'] = ucic;
    data['emailId'] = emailId;
    data['oldEmailId'] = oldEmailId;
    data['consentFlag'] = consentFlag;
    data['superAppId'] = superAppId;
    data['source'] = source;
    data['customerName'] = customerName;
    return data;
  }
}
