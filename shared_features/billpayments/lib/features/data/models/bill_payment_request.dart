class BillPaymentRequest {
  String? mobileNumber;

  BillPaymentRequest(
      {this.mobileNumber});

  BillPaymentRequest.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['mobileNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobileNumber'] = mobileNumber;
    return data;
  }
}
