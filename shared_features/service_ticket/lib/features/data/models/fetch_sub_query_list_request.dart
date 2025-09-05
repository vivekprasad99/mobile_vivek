class FetchSubQueryListRequest {
  String? query;

  FetchSubQueryListRequest({this.query});

  FetchSubQueryListRequest.fromJson(Map<String, dynamic> json) {
    query = json['query'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['query'] = query;
    return data;
  }
}
