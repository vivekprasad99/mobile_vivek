class AddressUpdateOfflineResponse {
  String? code;
  String? message;
  String? responseCode;
  String? operation;

  AddressUpdateOfflineResponse(
      {this.code, this.message, this.responseCode, this.operation});

  AddressUpdateOfflineResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    responseCode = json['responseCode'];
    operation = json['operation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['responseCode'] = responseCode;
    data['operation'] = operation;
    return data;
  }
}
