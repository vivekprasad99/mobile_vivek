class CampsOutputReq {
  String? encryptedRequest;
  String? superAppId;
  String? source;

  CampsOutputReq({this.encryptedRequest, this.source, this.superAppId});

  CampsOutputReq.fromJson(Map<String, dynamic> json) {
    encryptedRequest = json['encryptedRequest'];
    source = json['source'];
    superAppId = json['superAppId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['encryptedRequest'] = encryptedRequest;
    data['source'] = source;
    data['superAppId'] = superAppId;
    return data;
  }
}