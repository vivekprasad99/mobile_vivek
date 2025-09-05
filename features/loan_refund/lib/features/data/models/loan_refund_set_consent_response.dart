class SetConsentResponse {
  final String? code;
  final String? responseCode;
  final String? message;

  SetConsentResponse({
    this.code,
    this.responseCode,
    this.message,
  });

  factory SetConsentResponse.fromJson(Map<String, dynamic> json) =>
      SetConsentResponse(
        code: json["code"],
        responseCode: json["responseCode"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "responseCode": responseCode,
        "message": message,
      };
}
