class SearchRequest {
  String? searchQuery;

  SearchRequest({this.searchQuery});

  SearchRequest.fromJson(Map<String, dynamic> json) {
    searchQuery = json['query'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['query'] = searchQuery;
    return data;
  }
}