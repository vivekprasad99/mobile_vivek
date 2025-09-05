class ValidateDeviceResponse {
  bool? deviceExist;
  String? code;
  String? message;
  String? responseCode;
  bool? canAddProfileToDevice;
  List<Profiles>? profiles;

  ValidateDeviceResponse(
      {this.deviceExist, this.code, this.message, this.responseCode,this.canAddProfileToDevice, this.profiles, });

  ValidateDeviceResponse.fromJson(Map<String, dynamic> json) {
    deviceExist = json['deviceExist'];
    code = json['code'];
    message = json['message'];
    responseCode = json['responseCode'];
    canAddProfileToDevice = json['canAddProfileToDevice'];
    if (json['profiles'] != null) {
      profiles = <Profiles>[];
      json['profiles'].forEach((v) {
        profiles!.add(Profiles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deviceExist'] = deviceExist;
    data['code'] = code;
    data['message'] = message;
    data['responseCode'] = responseCode;
    data['canAddProfileToDevice'] = canAddProfileToDevice;
    if (profiles != null) {
      data['profiles'] = profiles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Profiles {
  String? superAppId;
  String? mobileNumber;
  String? userFullName;
  String? languageCode;
  String? theme;
  String? ucic;
  bool? isCustomer;
  bool? mpinExists;

  Profiles(
      {this.superAppId,
        this.mobileNumber,
        this.userFullName,
        this.languageCode,
        this.theme,
        this.ucic,
        this.isCustomer, this.mpinExists,});

  Profiles.fromJson(Map<String, dynamic> json) {
    superAppId = json['superAppId'];
    mobileNumber = json['mobileNumber'];
    userFullName = json['userFullName'];
    languageCode = json['languageCode'];
    theme = json['theme'];
    ucic = json['ucic'];
    isCustomer = json['isCustomer'];
    mpinExists = json['mpinExists'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['superAppId'] = superAppId;
    data['mobileNumber'] = mobileNumber;
    data['userFullName'] = userFullName;
    data['languageCode'] = languageCode;
    data['theme'] = theme;
    data['ucic'] = ucic;
    data['isCustomer'] = isCustomer;
    data['mpinExists'] = mpinExists;
    return data;
  }
}
