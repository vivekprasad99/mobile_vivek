class FetchModelListResponse {
  String? code;
  String? message;
  List<Data>? data;

  FetchModelListResponse({this.code, this.message, this.data});

  FetchModelListResponse.fromJson(Map<String, dynamic> json) {
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
  String? model;
  String? modelCode;

  Data({this.model, this.modelCode});

  Data.fromJson(Map<String, dynamic> json) {
    model = json['model'];
    modelCode = json['modelCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['model'] = model;
    data['modelCode'] = modelCode;
    return data;
  }
}
