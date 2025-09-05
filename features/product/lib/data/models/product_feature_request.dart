class ProductFeatureRequest {
  String? ucic;

  ProductFeatureRequest({this.ucic});

  ProductFeatureRequest.fromJson(Map<String, dynamic> json) {
    ucic = json['deviceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deviceId'] = ucic;
    return data;
  }
}
