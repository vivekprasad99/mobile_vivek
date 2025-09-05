class OpenServiceRequestResponse {
  String? status;
  String? message;
  List<Data>? data;

  OpenServiceRequestResponse({this.status, this.message, this.data});

  OpenServiceRequestResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
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
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? serviceRequestNumber;
  String? updatedDate;
  String? createdDate;
  String? product;
  String? subProduct;

  Data(
      {this.serviceRequestNumber,
      this.updatedDate,
      this.createdDate,
      this.product,
      this.subProduct});

  Data.fromJson(Map<String, dynamic> json) {
    serviceRequestNumber = json['serviceRequestNumber'];
    updatedDate = json['updatedDate'];
    createdDate = json['createdDate'];
    product = json['product'];
    subProduct = json['subProduct'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['serviceRequestNumber'] = serviceRequestNumber;
    data['updatedDate'] = updatedDate;
    data['createdDate'] = createdDate;
    data['product'] = product;
    data['subProduct'] = subProduct;
    return data;
  }
}
