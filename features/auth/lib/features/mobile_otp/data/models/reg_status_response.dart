class RegisterStatusResponse {
  bool? isCustomer;
  bool? isPanAvailable;
  int? ucicCount;
  String? code;
  String? message;
  String? responseCode;

  RegisterStatusResponse(
      {
        this.isCustomer,
        this.isPanAvailable,
        this.ucicCount,
        this.code,
        this.message, this.responseCode});

  RegisterStatusResponse.fromJson(Map<String, dynamic> json) {
    isCustomer = json['isCustomer'];
    isPanAvailable = json['isPanAvailable'];
    ucicCount = json['ucicCount'];
    code = json['code'];
    message = json['message'];
    responseCode = json['responseCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isCustomer'] = isCustomer;
    data['isPanAvailable'] = isPanAvailable;
    data['ucicCount'] = ucicCount;
    data['code'] = code;
    data['message'] = message;
    data['responseCode'] = responseCode;
    return data;
  }
}