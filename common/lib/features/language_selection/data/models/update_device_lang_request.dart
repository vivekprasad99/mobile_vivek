class UpdateUserLangRequest {
  String? languageCode;
  String? superAppId;
  String? source;

  UpdateUserLangRequest({this.languageCode,this.superAppId, this.source});

  UpdateUserLangRequest.fromJson(Map<String, dynamic> json) {
    languageCode = json['languageCode'];
    superAppId = json['superAppId'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['languageCode'] = languageCode;
    data['superAppId'] = superAppId;
    data['source'] = source;
    return data;
  }
}
