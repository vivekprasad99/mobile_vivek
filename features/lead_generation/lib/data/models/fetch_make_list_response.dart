class FetchMakeListResponse {
  String? code;
  String? message;
  List<Data>? data;

  FetchMakeListResponse({this.code, this.message, this.data});

  FetchMakeListResponse.fromJson(Map<String, dynamic> json) {
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
  String? make;
  String? makeCode;

  Data({this.make, this.makeCode});

  Data.fromJson(Map<String, dynamic> json) {
    make = json['make'];
    makeCode = json['makeCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['make'] = make;
    data['makeCode'] = makeCode;
    return data;
  }
}
