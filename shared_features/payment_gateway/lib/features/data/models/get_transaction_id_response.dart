class GetTransactionIdResponse {
  String code;
  String message;
  String responseCode;
  String transactionId;

  GetTransactionIdResponse({
    required this.code,
    required this.message,
    required this.responseCode,
    required this.transactionId,
  });

  factory GetTransactionIdResponse.fromJson(Map<String, dynamic> json) =>
      GetTransactionIdResponse(
        code: json["code"] ?? "",
        message: json["message"] ?? "",
        responseCode: json["responseCode"] ?? "",
        transactionId: json["transactionId"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "responseCode": responseCode,
        "transactionId": transactionId,
      };
}
