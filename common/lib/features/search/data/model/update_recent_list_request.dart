class UpdateRecentListRequest {
  String? superAppId;
  List<String?>? recentList;

  UpdateRecentListRequest({this.superAppId,this.recentList});

  UpdateRecentListRequest.fromJson(Map<String, dynamic> json) {
    superAppId = json['superAppId'];
    recentList = json['searchKeys'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['superAppId'] = superAppId;
    data['searchKeys'] = recentList;
    return data;
  }
}