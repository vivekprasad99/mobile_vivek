class MPinRequest {
  String? mPin;
  String? superAppId;
  String? source;

  MPinRequest({this.mPin,this.superAppId,this.source});

  MPinRequest.fromJson(Map<String, dynamic> json) {
    mPin = json['mpin'];
    superAppId = json['superAppId'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mpin'] = mPin;
    data['superAppId'] = superAppId;
    data['source'] = source;
    return data;
  }
}