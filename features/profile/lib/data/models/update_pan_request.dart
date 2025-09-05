class UpdatePanRequest {
  String? pan;
  String? dob;
  String? name;
  String? ucic;
  String? source;
  String? superAppId;
  String? consentFlag;

  UpdatePanRequest(
      {this.pan,
      this.dob,
      this.name,
      this.ucic,
      this.source,
      this.superAppId,
      this.consentFlag});

  UpdatePanRequest.fromJson(Map<String, dynamic> json) {
    pan = json['pan'];
    dob = json['dob'];
    name = json['name'];
    ucic = json['ucic'];
    source = json['source'];
    superAppId = json['superAppId'];
    consentFlag = json['consentFlag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pan'] = pan;
    data['dob'] = dob;
    data['name'] = name;
    data['ucic'] = ucic;
    data['source'] = source;
    data['superAppId'] = superAppId;
    data['consentFlag'] = consentFlag;
    return data;
  }
}
