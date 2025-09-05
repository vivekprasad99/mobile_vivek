class ProfileImageResponse {
  String? code;
  String? message;
  String? responseCode;
  String? profileImage;

  ProfileImageResponse(
      {this.code, this.message, this.responseCode, this.profileImage});

  ProfileImageResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    responseCode = json['responseCode'];
    profileImage = json['profileImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['responseCode'] = responseCode;
    data['profileImage'] = profileImage;
    return data;
  }
}
