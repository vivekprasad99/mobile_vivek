class UpdateEnachStatusRequest {
  final String? status;
  final String? umrn;
  final String? requestId;

  UpdateEnachStatusRequest({
    this.status,
    this.umrn,
    this.requestId,
  });

  factory UpdateEnachStatusRequest.fromJson(Map<String, dynamic> json) =>
      UpdateEnachStatusRequest(
        status: json["status"],
        umrn: json["UMRN"],
        requestId: json["requestId"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "UMRN": umrn,
        "requestId": requestId,
      };
}
