class CreateSrResponse {
  final String? code;
  final String? message;
  final String? responseCode;
  final CreateSrData? data;

  CreateSrResponse({
    this.code,
    this.message,
    this.responseCode,
    this.data,
  });

  factory CreateSrResponse.fromJson(Map<String, dynamic> json) =>
      CreateSrResponse(
        code: json["code"],
        message: json["message"],
        responseCode: json["responseCode"],
        data: json["data"] == null ? null : CreateSrData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "responseCode": responseCode,
        "data": data?.toJson(),
      };
}

class CreateSrData {
  final String? serviceTicketNumber;

  CreateSrData({
    this.serviceTicketNumber,
  });

  factory CreateSrData.fromJson(Map<String, dynamic> json) => CreateSrData(
        serviceTicketNumber: json["ServiceTicket-Number"],
      );

  Map<String, dynamic> toJson() => {
        "ServiceTicket-Number": serviceTicketNumber,
      };
}
