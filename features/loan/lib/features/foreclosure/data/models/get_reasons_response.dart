class GetReasonsResponse {
  final String? status;
  final String? message;
  final List<Reasons>? data;

  GetReasonsResponse({
    this.status,
    this.message,
    this.data,
  });

  factory GetReasonsResponse.fromJson(Map<String, dynamic> json) =>
      GetReasonsResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Reasons>.from(json["data"]!.map((x) => Reasons.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Reasons {
  final int? id;
  final String? name;

  Reasons({
    this.id,
    this.name,
  });

  factory Reasons.fromJson(Map<String, dynamic> json) => Reasons(
        id: int.tryParse(json["id"]) ,
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
