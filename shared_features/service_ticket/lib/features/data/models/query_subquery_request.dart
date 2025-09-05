class FetchQuerySubQueryRequest {
  String? type;

  FetchQuerySubQueryRequest({this.type});
  FetchQuerySubQueryRequest.fromJson(Map<String, dynamic> json) {
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    return data;
  }
}
