class CreateFdLeadResponse {
  final String? status;
  final String? message;
  final FDleadId? data;

  CreateFdLeadResponse({
    this.status,
    this.message,
    this.data,
  });

  factory CreateFdLeadResponse.fromJson(Map<String, dynamic> json) =>
      CreateFdLeadResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : FDleadId.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class FDleadId {
  final String? fixedDepositLeadId;

  FDleadId({
    this.fixedDepositLeadId,
  });

  factory FDleadId.fromJson(Map<String, dynamic> json) => FDleadId(
        fixedDepositLeadId: json["fixedDepositLeadId"],
      );

  Map<String, dynamic> toJson() => {
        "fixedDepositLeadId": fixedDepositLeadId,
      };
}
