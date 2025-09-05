
class NameMatchRes {
  String? code;
  String? message;
  double? score;
  String? responseCode;

  NameMatchRes({this.code, this.message, this.score, this.responseCode});

  NameMatchRes.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    responseCode = json['responseCode'];
    score = json['score']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['responseCode'] = responseCode;
    data['score'] = score;
    return data;
  }
}
