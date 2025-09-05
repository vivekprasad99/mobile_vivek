class FetchDealershipListResponse {
  String? code;
  String? message;
  List<Data>? data;

  FetchDealershipListResponse({this.code, this.message, this.data});

  FetchDealershipListResponse.fromJson(Map<String, dynamic> json) {
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
  String? dealership;
  String? dealershipCode;

  Data({this.dealership, this.dealershipCode});

  Data.fromJson(Map<String, dynamic> json) {
    dealership = json['dealership'];
    dealershipCode = json['dealershipCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dealership'] = dealership;
    data['dealershipCode'] = dealershipCode;
    return data;
  }
}
