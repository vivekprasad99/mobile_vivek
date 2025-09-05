class RateUsRequest {
  String? superAppId;
  String? feature;

  RateUsRequest({this.superAppId, this.feature});

  RateUsRequest.fromJson(Map<String, dynamic> json) {
    superAppId = json['superAppId'];
    feature = json['feature'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['superAppId'] = superAppId;
    data['feature'] = feature;
    return data;
  }
}
