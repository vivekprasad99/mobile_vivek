class ResultData {
  ResultData({
    this.result,
    this.message,
  });

  ResultData.fromJson(dynamic json) {
    result = json['result'];
    message = json['message'];
  }
  String? result;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['result'] = result;
    map['message'] = message;
    return map;
  }
}
