class SetConsentRequest {
  String? superAppId;
  String? refundConsent = "RefundConsent";
  bool? consentFlag = true;

  SetConsentRequest({this.superAppId, this.consentFlag, this.refundConsent});

  SetConsentRequest.fromJson(Map<String, dynamic> json) {
    superAppId = json['superAppId'];
    refundConsent = json['refundConsent'];
    consentFlag = json['consentFlag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['superAppId'] = superAppId;
    data['refundConsent'] = refundConsent;
    data['consentFlag'] = consentFlag;
    return data;
  }
}
