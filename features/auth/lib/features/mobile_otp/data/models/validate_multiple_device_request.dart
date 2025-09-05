class ValidateMultiPleDeviceRequest {
  String? deviceId;
  String? mobileNumber;
  String? source;

  ValidateMultiPleDeviceRequest(
      {this.deviceId, this.mobileNumber, this.source});

  ValidateMultiPleDeviceRequest.fromJson(Map<String, dynamic> json) {
    deviceId = json['deviceId'];
    mobileNumber = json['mobileNumber'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deviceId'] = deviceId;
    data['mobileNumber'] = mobileNumber;
    data['source'] = source;
    return data;
  }
}
