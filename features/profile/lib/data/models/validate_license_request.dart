class ValidateLicenseRequest {
  String? dlNo;
  String? dob;
  String? ucic;
  String? source;
  String? superAppId;

  ValidateLicenseRequest(
      {this.dlNo,
      this.dob,
      this.ucic,
      this.source,
      this.superAppId});

  ValidateLicenseRequest.fromJson(Map<String, dynamic> json) {
    dlNo = json['dlNo'];
    dob = json['dob'];
    ucic = json['ucic'];
    source = json['source'];
    superAppId = json['superAppId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dlNo'] = dlNo;
    data['dob'] = dob;
    data['ucic'] = ucic;
    data['source'] = source;
    data['superAppId'] = superAppId;
    return data;
  }
}
