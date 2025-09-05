class ReasonResponse {
  final String? status;
  final String? message;
  final List< Reason>? data;

  ReasonResponse({this.status, this.message, this.data});

  factory ReasonResponse.fromJson(Map<String, dynamic> json) => ReasonResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Reason>.from(json["data"]!.map((x) => Reason.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Reason {
  final String? id;
  final String? name;
  final String? image;

  Reason({this.id, this.name, this.image});

  factory Reason.fromJson(Map<String, dynamic> json) => Reason(
    id: json["id"],
    name: json["name"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "value": name,
    "image": image,
  };
}

