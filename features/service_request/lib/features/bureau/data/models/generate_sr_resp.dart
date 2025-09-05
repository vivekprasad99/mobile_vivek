class GenerateSrResponse {
  final String? srTicketNumber;
  final String? code;
  final String? message;

  GenerateSrResponse({
    this.srTicketNumber,
    this.code,
    this.message,
  });

  factory GenerateSrResponse.fromJson(Map<String, dynamic> json) =>
      GenerateSrResponse(
        srTicketNumber: json["srTicketNumber"],
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "srTicketNumber": srTicketNumber,
    "code": code,
    "message": message,
  };
}
