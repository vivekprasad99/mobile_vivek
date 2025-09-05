class GetRecentListResponse {
  String? code;
  String? message;
  String? responseCode;
  Data? data;

  GetRecentListResponse(
      {this.code, this.message, this.responseCode, this.data,});

  GetRecentListResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    responseCode = json['responseCode'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['responseCode'] = responseCode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? superAppId;
  List<String>? searchKeys;
  bool? recordFound;

  Data({this.superAppId, this.searchKeys, this.recordFound});

  Data.fromJson(Map<String, dynamic> json) {
    superAppId = json['superAppId'];
    searchKeys = json['searchKeys'] != null ? List<String>.from(json["searchKeys"].map((x) => x)) : [];
    recordFound = json['recordFound'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['superAppId'] = superAppId;
    data['searchKeys'] = data['searchKeys'] != null ? List<dynamic>.from(searchKeys!.map((x) => x)) : [];
    data['recordFound'] = recordFound;
    return data;
  }
}
