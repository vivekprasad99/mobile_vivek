class ApplicationStatusCategoryResponse {
  Meta? meta;
  List<Data>? data;
  String? message;

  ApplicationStatusCategoryResponse({this.meta, this.data,this.message});

  ApplicationStatusCategoryResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    if (json['data'] != null || json['data'] != {}) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    if (this.data != null||this.data != {}) {
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
        ? QueryParams.fromJson(json['query_params'])
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
  String? statusType;

  QueryParams({this.statusType});

  QueryParams.fromJson(Map<String, dynamic> json) {
    statusType = json['status_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status_type'] = statusType;
    return data;
  }
}

class Data {
  int? id;
  String? value;

  Data({this.id, this.value});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['value'] = value;
    return data;
  }
}
