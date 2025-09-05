class ValidateDeviceRequest {
  String? deviceId;
  String? source;

  ValidateDeviceRequest(
      {this.deviceId, this.source,});

  ValidateDeviceRequest.fromJson(Map<String, dynamic> json) {
    deviceId = json['deviceId'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deviceId'] = deviceId;
    data['source'] = source;
    return data;
  }
}
