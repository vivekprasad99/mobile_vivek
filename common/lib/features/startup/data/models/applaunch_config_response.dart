class AppLaunchConfigResponse {
  String? code;
  String? message;
  String? iosBuildVersion;
  String? androidBuildVersion;
  bool? iosForceUpdateFlag;
  bool? androidForceUpdateFlag;
  int? createMpinMaxAttempt;
  int? maxPanLanAttempts;
  String? paymentTat;

  AppLaunchConfigResponse(
      {this.code, this.message, this.iosBuildVersion, this.androidBuildVersion, this.iosForceUpdateFlag, this.androidForceUpdateFlag, this.createMpinMaxAttempt, this.maxPanLanAttempts,this.paymentTat});

  AppLaunchConfigResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    iosBuildVersion = json['iosBuildVersion'];
    androidBuildVersion = json['androidBuildVersion'];
    iosForceUpdateFlag = json['iosForceUpdateFlag'];
    androidForceUpdateFlag = json['androidForceUpdateFlag'];
    createMpinMaxAttempt = json['createMpinMaxAttempt'];
    maxPanLanAttempts = json['maxPanLanAttempts'];
    paymentTat = json['paymentTat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['iosBuildVersion'] = iosBuildVersion;
    data['androidBuildVersion'] = androidBuildVersion;
    data['androidForceUpdateFlag'] = androidForceUpdateFlag;
    data['createMpinMaxAttempt'] = createMpinMaxAttempt;
    data['maxPanLanAttempts'] = maxPanLanAttempts;
    data['paymentTat'] = paymentTat;
    return data;
  }
}