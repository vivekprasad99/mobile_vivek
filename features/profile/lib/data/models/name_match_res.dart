class NameMatchRes {
  String? code;
  String? message;
  String? responseCode;
  int? score;

  NameMatchRes({this.code, this.message, this.responseCode, this.score});

  NameMatchRes.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    responseCode = json['responseCode'];
    score = json['score'];
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
