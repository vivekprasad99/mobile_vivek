class DeleteProfileResp {
  final String code;
  final String message;
  final String responseCode;

  DeleteProfileResp({
    required this.code,
    required this.message,
    required this.responseCode,
  });

  factory DeleteProfileResp.fromJson(Map<String, dynamic> json) =>
      DeleteProfileResp(
        code: json["code"],
        message: json["message"],
        responseCode: json["responseCode"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "responseCode": responseCode,
      };
}
