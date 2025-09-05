class FetchPinCodeRequest {
  String? pinCode;

  FetchPinCodeRequest({this.pinCode});

  FetchPinCodeRequest.fromJson(Map<String, dynamic> json) {
    pinCode = json['pinCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pinCode'] = pinCode;
    return data;
  }
}
