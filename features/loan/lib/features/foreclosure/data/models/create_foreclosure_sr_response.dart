class CreateForeclosureSrResponse {
  final String? code;
  final String? status;
  final String? message;
  final Data? data;

  CreateForeclosureSrResponse({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  factory CreateForeclosureSrResponse.fromJson(Map<String, dynamic> json) =>
      CreateForeclosureSrResponse(
        status: json["status"],
        code: json["code"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code" :code,
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  final String? serviceRequestNumber;

  Data({
    this.serviceRequestNumber,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        serviceRequestNumber: json["ServiceTicket-Number"],
      );

  Map<String, dynamic> toJson() => {
        "serviceRequestNumber": serviceRequestNumber,
      };
}
