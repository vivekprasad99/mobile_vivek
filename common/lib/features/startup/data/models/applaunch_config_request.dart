class AppLaunchConfigRequest {
  String? appVersion;

  AppLaunchConfigRequest(
      {this.appVersion,});

  AppLaunchConfigRequest.fromJson(Map<String, dynamic> json) {
    appVersion = json['appVersion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appVersion'] = appVersion;
    return data;
  }
}
