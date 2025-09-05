class FetchQuerySubQueryResponse {
  String? status;
  Meta? meta;
  String? message;
  List<Data>? data;
  FetchQuerySubQueryResponse({this.status, this.meta, this.message, this.data});
  FetchQuerySubQueryResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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
  Meta({this.total});
  Meta.fromJson(Map<String, dynamic> json) {
    total = json['total'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    return data;
  }
}
class Data {
  String? tid;
  String? type;
  String? query;
  List<SubQuery>? subQuery;
  Data({this.tid, this.query, this.subQuery});
  Data.fromJson(Map<String, dynamic> json) {
    tid = json['tid'];
    query = json['query'];
    type = json['type'];
    if (json['sub_query'] != null) {
      subQuery = <SubQuery>[];
      json['sub_query'].forEach((v) {
        subQuery!.add(SubQuery.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tid'] = tid;
    data['query'] = query;
    if (subQuery != null) {
      data['sub_query'] = subQuery!.map((v) => v.toJson()).toList();
    }
    data['type'] = type;
    return data;
  }
}
class SubQuery {
  String? tid;
  String? name;
  String? caseType;
  String? product;
  String? lanMandatory;

  SubQuery({this.tid, this.name, this.caseType, this.product, this.lanMandatory});

  SubQuery.fromJson(Map<String, dynamic> json) {
    tid = json['tid'];
    name = json['name'];
    caseType = json['case_type'];
    product = json['product'];
    lanMandatory = json['lan_mandatory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tid'] = tid;
    data['name'] = name;
    data['case_type'] = caseType;
    data['product'] = product;
    data['lan_mandatory'] = lanMandatory;
    return data;
  }

}