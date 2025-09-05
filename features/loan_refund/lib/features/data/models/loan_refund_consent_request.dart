class LoanRefundConsentRequest {
  String? superAppId;
  String? feature;
  bool? consentFlag;

  LoanRefundConsentRequest({this.superAppId, this.feature, this.consentFlag});

  LoanRefundConsentRequest.fromJson(Map<String, dynamic> json) {
    superAppId = json['superAppId'];
    feature = json['feature'];
    consentFlag = json['consentFlag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['superAppId'] = superAppId;
    data['feature'] = feature;
    data['consentFlag'] = consentFlag;
    return data;
  }

}