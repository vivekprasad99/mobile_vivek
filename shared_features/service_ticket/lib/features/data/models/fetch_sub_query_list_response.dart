class FetchSubQueryListResponse {
  String? code;
  String? message;
  List<Data>? data;

  FetchSubQueryListResponse({this.code, this.message, this.data});

  FetchSubQueryListResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
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
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? subQuery;

  Data({this.subQuery});

  Data.fromJson(Map<String, dynamic> json) {
    subQuery = json['subQuery'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subQuery'] = subQuery;
    return data;
  }
}
