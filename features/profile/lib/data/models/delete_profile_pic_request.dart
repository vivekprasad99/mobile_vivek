class DeleteProfilePhotoRequest {
  String? ucic;
  String? superAppId;

  DeleteProfilePhotoRequest({this.ucic, this.superAppId});

  DeleteProfilePhotoRequest.fromJson(Map<String, dynamic> json) {
    ucic = json['ucic'];
    superAppId = json['superAppId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ucic'] = ucic;
    data['superAppId'] = superAppId;
    return data;
  }
}
