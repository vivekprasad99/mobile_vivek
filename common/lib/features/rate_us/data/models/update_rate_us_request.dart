class UpdateRateUsRequest {
  String? superAppId;
  String? feature;
  int? rating;
  String? comment;

  UpdateRateUsRequest(
      {this.superAppId, this.feature, this.rating, this.comment,});

  UpdateRateUsRequest.fromJson(Map<String, dynamic> json) {
    superAppId = json['superAppId'];
    feature = json['feature'];
    rating = json['rating'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['superAppId'] = superAppId;
    data['feature'] = feature;
    data['rating'] = rating;
    data['comment'] = comment;
    return data;
  }
}
