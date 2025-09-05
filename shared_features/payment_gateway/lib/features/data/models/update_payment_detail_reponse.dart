class UpdatePaymentDetailResponse {
  String code;
  String message;
  String responseCode;

  UpdatePaymentDetailResponse({
    required this.code,
    required this.message,
    required this.responseCode,
  });

  factory UpdatePaymentDetailResponse.fromJson(Map<String, dynamic> json) =>
      UpdatePaymentDetailResponse(
        code: json["code"] ?? "",
        message: json["message"] ?? "",
        responseCode: json["responseCode"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "responseCode": responseCode,
      };
}
