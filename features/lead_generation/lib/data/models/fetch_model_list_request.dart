class FetchModelListRequest {
  String? makeCode;

  FetchModelListRequest({this.makeCode});

  FetchModelListRequest.fromJson(Map<String, dynamic> json) {
    makeCode = json['makeCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['makeCode'] = makeCode;
    return data;
  }
}
