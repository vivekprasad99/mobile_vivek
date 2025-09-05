class RecommendedListResponse {
  String? status;
  Meta? meta;
  String? message;
  List<Data>? data;

  RecommendedListResponse({this.status, this.meta, this.message, this.data});

  RecommendedListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    meta = json['meta'] != null ?  Meta.fromJson(json['meta']) : null;
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add( Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Meta {
  int? total;
  QueryParams? queryParams;

  Meta({this.total, this.queryParams});

  Meta.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    queryParams = json['query_params'] != null
        ?  QueryParams.fromJson(json['query_params'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    if (queryParams != null) {
      data['query_params'] = queryParams!.toJson();
    }
    return data;
  }
}

class QueryParams {
  String? language;
  String? category;

  QueryParams({this.language, this.category});

  QueryParams.fromJson(Map<String, dynamic> json) {
    language = json['language'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['language'] = language;
    data['category'] = category;
    return data;
  }
}

class Data {
  String? id;
  String? title;

  Data({this.id, this.title});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    return data;
  }
}
