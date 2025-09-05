class GetLoanCancellationReasonsResponse {
  final String? status;
  final String? message;
  final List<CancelReasons>? data;

  GetLoanCancellationReasonsResponse({
    this.status,
    this.message,
    this.data,
  });

  factory GetLoanCancellationReasonsResponse.fromJson(
          Map<String, dynamic> json) =>
      GetLoanCancellationReasonsResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<CancelReasons>.from(
                json["data"]!.map((x) => CancelReasons.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class CancelReasons {
  final String? id;
  final String? name;

  CancelReasons({
    this.id,
    this.name,
  });

  factory CancelReasons.fromJson(Map<String, dynamic> json) => CancelReasons(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
