class MyProfileRequest {
  String? ucic;
  String? source;
  String? superAppId;

  MyProfileRequest({this.ucic, this.source, this.superAppId});

  MyProfileRequest.fromJson(Map<String, dynamic> json) {
    ucic = json['ucic'];
    source = json['source'];
    superAppId = json['superAppId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ucic'] = ucic;
    data['source'] = source;
    data['superAppId'] = superAppId;
    return data;
  }
}
