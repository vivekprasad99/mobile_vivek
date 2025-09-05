class SaveDeviceRequest {
  String? deviceId;
  String? superAppId;
  String? source;

  SaveDeviceRequest(
      {this.deviceId, this.superAppId, this.source});

  SaveDeviceRequest.fromJson(Map<String, dynamic> json) {
    deviceId = json['deviceId'];
    superAppId = json['superAppId'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deviceId'] = deviceId;
    data['superAppId'] = superAppId;
    data['source'] = source;
    return data;
  }
}
