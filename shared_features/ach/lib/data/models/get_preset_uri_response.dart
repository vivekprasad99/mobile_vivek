class GetPresetUriResponse {
  String? code;
  String? message;
  String? filename;
  String? presetURL;
  String? responseCode;

  GetPresetUriResponse({this.code,this.message,this.filename,this.presetURL, this.responseCode});

  GetPresetUriResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    filename = json['filename'];
    presetURL = json['presetURL'];
    responseCode = json['responseCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['filename'] = filename;
    data['presetURL'] = presetURL;
    data['responseCode'] = responseCode;
    return data;
  }
}
