class ValidateDeviceByUcicReq{
  String? deviceId;
  String? ucic;
  String? source;


  ValidateDeviceByUcicReq(
      {this.deviceId, this.ucic, this.source});

  ValidateDeviceByUcicReq.fromJson(Map<String, dynamic> json) {
    deviceId = json['deviceId'];
    ucic = json['ucic'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deviceId'] = deviceId;
    data['ucic'] = ucic;
    data['source'] = source;
    return data;
  }
}