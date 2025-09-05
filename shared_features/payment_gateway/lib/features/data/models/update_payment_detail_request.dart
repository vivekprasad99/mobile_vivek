class UpdatePaymentDetailRequest {
  String uniqueTrackingId;
  String pgResponse;
  String paymentStatusUi;

  UpdatePaymentDetailRequest({
    required this.uniqueTrackingId,
    required this.pgResponse,
    required this.paymentStatusUi,
  });

  factory UpdatePaymentDetailRequest.fromJson(Map<String, dynamic> json) =>
      UpdatePaymentDetailRequest(
        uniqueTrackingId: json["uniqueTrackingId"],
        pgResponse: json["pgResponse"],
        paymentStatusUi: json["paymentStatusUI"],
      );

  Map<String, dynamic> toJson() => {
        "uniqueTrackingId": uniqueTrackingId,
        "pgResponse": pgResponse,
        "paymentStatusUI": paymentStatusUi,
      };
}
