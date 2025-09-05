class TermsConditionsResponse {
  final String? status;
  final String? message;
  final String? data;
  TermsConditionsResponse({this.status, this.message, this.data});

  factory TermsConditionsResponse.fromJson(Map<String, dynamic> json) =>
      TermsConditionsResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data,
      };
}
