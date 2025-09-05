class UpdatePanResponse {
  String? code;
  String? message;
  String? responseCode;
  String? operation;
  List<Response>? response;

  UpdatePanResponse(
      {this.code,
      this.message,
      this.responseCode,
      this.operation,
      this.response});

  UpdatePanResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    responseCode = json['responseCode'];
    operation = json['Operation'];
    if (json['Response'] != null) {
      response = <Response>[];
      json['Response'].forEach((v) {
        response!.add(Response.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['responseCode'] = responseCode;
    data['Operation'] = operation;
    if (response != null) {
      data['Response'] = response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Response {
  String? source;
  String? laonNumber;
  String? productName;
  String? status;

  Response({this.source, this.laonNumber, this.productName, this.status});

  Response.fromJson(Map<String, dynamic> json) {
    source = json['source'];
    laonNumber = json['laonNumber'];
    productName = json['productName'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['source'] = source;
    data['laonNumber'] = laonNumber;
    data['productName'] = productName;
    data['status'] = status;
    return data;
  }
}
