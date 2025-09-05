class RateUsResponse {
  String? code;
  bool? rateUsStatus;
  String? message;
  String? responseCode;

  RateUsResponse({this.code, this.rateUsStatus,this.message,this.responseCode});

  RateUsResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    rateUsStatus = json['rateUsStatus'];
    message = json['message'];
    responseCode = json['responseCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['rateUsStatus'] = rateUsStatus;
    data['message'] = message;
    data['responseCode'] = responseCode;
    return data;
  }
}
