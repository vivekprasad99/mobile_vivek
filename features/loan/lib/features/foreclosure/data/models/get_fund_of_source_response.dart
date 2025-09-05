class FundOfSourceResponse {
  final String? status;
  final String? message;
  final List<FundOfSource>? data;

  FundOfSourceResponse({
    this.status,
    this.message,
    this.data,
  });

  factory FundOfSourceResponse.fromJson(Map<String, dynamic> json) =>
      FundOfSourceResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<FundOfSource>.from(
                json["data"]!.map((x) => FundOfSource.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class FundOfSource {
  final int? id;
  final String? name;

  FundOfSource({
    this.id,
    this.name,
  });

  factory FundOfSource.fromJson(Map<String, dynamic> json) => FundOfSource(
        id: int.tryParse(json["id"]),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
