 class SRDetailsRequest {
  String? caseNumber;
  SRDetailsRequest({ this.caseNumber});

  SRDetailsRequest.fromJson(Map<String, dynamic> json) {
    caseNumber = json['caseNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['caseNumber'] = caseNumber;
    return data;
  }
}
