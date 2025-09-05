class NupayStatusReq {
  String? nupayId;
  String? superAppId;
  String? source;

  NupayStatusReq({this.nupayId, this.source, this.superAppId});

  NupayStatusReq.fromJson(Map<String, dynamic> json) {
    nupayId = json['nupayId'];
    source = json['source'];
    superAppId = json['superAppId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nupayId'] = nupayId;
    data['source'] = source;
    data['superAppId'] = superAppId;
    return data;
  }
}