class GetThemeRequest {
  String? superAppId;
  String? source;

  GetThemeRequest({this.superAppId, this.source});

  GetThemeRequest.fromJson(Map<String, dynamic> json) {
    superAppId = json['superAppId'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['superAppId'] = superAppId;
    data['source'] = source;
    return data;
  }
}
