class ValidatePANRequest {
  String? pan;
  String? dob;
  String? name;
  String? ucic;
  String? source;
  String? superAppId;

  ValidatePANRequest(
      {this.pan, this.dob, this.name, this.ucic, this.source, this.superAppId});

  ValidatePANRequest.fromJson(Map<String, dynamic> json) {
    pan = json['pan'];
    dob = json['dob'];
    name = json['name'];
    ucic = json['ucic'];
    source = json['source'];
    superAppId = json['superAppId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pan'] = pan;
    data['dob'] = dob;
    data['name'] = name;
    data['ucic'] = ucic;
    data['source'] = source;
    data['superAppId'] = superAppId;
    return data;
  }
}
