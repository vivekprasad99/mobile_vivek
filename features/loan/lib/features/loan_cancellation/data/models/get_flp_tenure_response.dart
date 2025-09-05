class GetFlpTenureResponse {
  final String? status;
  final String? message;
  final DaysData? data;

  GetFlpTenureResponse({
    this.status,
    this.message,
    this.data,
  });

  factory GetFlpTenureResponse.fromJson(Map<String, dynamic> json) =>
      GetFlpTenureResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : (json["data"] is List)
                ? DaysData.fromJson(json["data"][0])
                : DaysData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class DaysData {
  final int? days;

  DaysData({
    this.days,
  });

  factory DaysData.fromJson(Map<String, dynamic> json) => DaysData(
        days: (int.tryParse(json["days"]) ?? 0),
      );

  Map<String, dynamic> toJson() => {
        "days": days,
      };
}
