class SetPaymentReminderResponse {
  final String? statusCode;
  final String? status;

  SetPaymentReminderResponse({
    this.statusCode,
    this.status,
  });

  factory SetPaymentReminderResponse.fromJson(Map<String, dynamic> json) =>
      SetPaymentReminderResponse(
        statusCode: json["statusCode"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "status": status,
      };
}
