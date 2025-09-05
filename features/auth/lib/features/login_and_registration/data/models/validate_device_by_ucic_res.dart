class ValidateDeviceByUcicRes{
  String? code;
  String? message;
  bool? sameDeviceExists;
  bool? otherDeviceExists;
  String? superAppId;
  String? responseCode;

  ValidateDeviceByUcicRes({this.code, this.message,this.sameDeviceExists,this.otherDeviceExists,this.superAppId, this.responseCode});

  ValidateDeviceByUcicRes.fromJson(Map<String, dynamic> json) {
  code = json['code'];
  message = json['message'];
  sameDeviceExists = json['sameDeviceExists'];
  otherDeviceExists = json['otherDeviceExists'];
  superAppId = json['superAppId'];
  responseCode = json['responseCode'];
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = code;
  data['message'] = message;
  data['sameDeviceExists'] = sameDeviceExists;
  data['otherDeviceExists'] = otherDeviceExists;
  data['superAppId'] = superAppId;
  data['responseCode'] = responseCode;
  return data;
  }
}