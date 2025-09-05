class BaseCMSResponse {
  Meta? meta;

  BaseCMSResponse({this.meta});

  BaseCMSResponse.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }
}

class Meta {
  int? total;
  QueryParams? queryParams;

  Meta({this.total, this.queryParams});

  Meta.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    queryParams = json['query_params'] != null
        ? QueryParams.fromJson(json['query_params'])
        : null;
  }
}

class QueryParams {
  String? language;

  QueryParams({this.language});

  QueryParams.fromJson(Map<String, dynamic> json) {
    language = json['language'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['language'] = language;
    return data;
  }
}
