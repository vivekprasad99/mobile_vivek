class GetBillPaymentResponse {
  String? message;
  String? responseCode;
  String? linkToRedirect;
  String? status;

  GetBillPaymentResponse(
      {this.message, this.responseCode, this.linkToRedirect, this.status});

  GetBillPaymentResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    responseCode = json['responseCode'];
    linkToRedirect = json['linkToRedirect'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['responseCode'] = responseCode;
    data['linkToRedirect'] = linkToRedirect;
    data['status'] = status;
    return data;
  }
}
