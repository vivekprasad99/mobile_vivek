class UploadProfilePhotoRequest {
  String? profileImage;
  String? ucic;
  String? superAppId;

  UploadProfilePhotoRequest({this.profileImage, this.ucic, this.superAppId});

  UploadProfilePhotoRequest.fromJson(Map<String, dynamic> json) {
    profileImage = json['profileImage'];
    ucic = json['ucic'];
    superAppId = json['superAppId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['profileImage'] = profileImage;
    data['ucic'] = ucic;
    data['superAppId'] = superAppId;
    return data;
  }
}
