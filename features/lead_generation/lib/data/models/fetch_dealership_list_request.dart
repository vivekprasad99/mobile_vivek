class FetchDealershipListRequest {
  String? modelCode;

  FetchDealershipListRequest({this.modelCode});

  FetchDealershipListRequest.fromJson(Map<String, dynamic> json) {
    modelCode = json['modelCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['modelCode'] = modelCode;
    return data;
  }
}
