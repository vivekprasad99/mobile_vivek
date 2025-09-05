class NameMatchReq {
  String? sourceName;
  String? targetName;
  String? ucic;
  String? superAppId;

  NameMatchReq({this.sourceName, this.targetName, this.ucic, this.superAppId});

  NameMatchReq.fromJson(Map<String, dynamic> json) {
    sourceName = json['sourceName'];
    targetName = json['targetName'];
    ucic = json['ucic'];
    superAppId = json['superAppId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sourceName'] = sourceName;
    data['targetName'] = targetName;
    data['ucic'] = ucic;
    data['superAppId'] = superAppId;
    return data;
  }
}
