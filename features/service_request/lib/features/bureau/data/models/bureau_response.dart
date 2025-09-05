class BureauResponse {
  final String? status;
  final String? message;
  final List< Bureau>? data;

  BureauResponse({this.status, this.message, this.data});

  factory BureauResponse.fromJson(Map<String, dynamic> json) => BureauResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Bureau>.from(json["data"]!.map((x) => Bureau.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Bureau {
  final int? id;
  final String? name;
  bool isSelected;

  Bureau({this.id, this.name, this.isSelected = false});

  factory Bureau.fromJson(Map<String, dynamic> json) => Bureau(
    id: json["id"],
    name: json["value"],
    isSelected: json["isSelected"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "value": name,
    "isSelected": isSelected,
  };
}

