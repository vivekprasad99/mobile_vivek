class UpdateEnachStatusResponse {
  final String? status;
  final String? message;
  String? responseCode;

  UpdateEnachStatusResponse({
    this.status,
    this.message,
    this.responseCode,
  });

  factory UpdateEnachStatusResponse.fromJson(Map<String, dynamic> json) =>
      UpdateEnachStatusResponse(
        status: json["status"],
        message: json["message"],
        responseCode: json["responseCode"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "responseCode": responseCode,
      };
}
