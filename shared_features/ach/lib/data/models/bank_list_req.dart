class BankListReq{
  String? superAppId;
  String? source;

  BankListReq({this.superAppId, this.source});

  BankListReq.fromJson(Map<String, dynamic> json) {
    superAppId = json['superAppId'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['superAppId'] = superAppId;
    data['source'] = source;
    return data;
  }
}