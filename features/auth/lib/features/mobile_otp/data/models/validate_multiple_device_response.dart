class ValidateMultipleDeviceResponse {
  String? code;
  String? message;
  bool? otherDeviceExists;
  bool? sameDeviceExists;
  String? superAppId;
  String? responseCode;

  ValidateMultipleDeviceResponse({this.code, this.message,this.otherDeviceExists,this.sameDeviceExists, this.superAppId, this.responseCode});

  ValidateMultipleDeviceResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    otherDeviceExists = json['otherDeviceExists'];
    sameDeviceExists = json['sameDeviceExists'];
    superAppId = json['superAppId'];
    responseCode = json['responseCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['otherDeviceExists'] = otherDeviceExists;
    data['sameDeviceExists'] = sameDeviceExists;
    data['superAppId'] = superAppId;
    data['responseCode'] = responseCode;
    return data;
  }
}