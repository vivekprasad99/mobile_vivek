class ProfileImageRequest {
  String? source;
  String? superAppId;

  ProfileImageRequest({this.source, this.superAppId});

  ProfileImageRequest.fromJson(Map<String, dynamic> json) {
    source = json['source'];
    superAppId = json['superAppId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['source'] = source;
    data['superAppId'] = superAppId;
    return data;
  }
}
