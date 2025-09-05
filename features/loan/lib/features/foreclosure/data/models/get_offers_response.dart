class GetOffersResponse {
  final String? status;
  final String? message;
  final List<Offers>? data;

  GetOffersResponse({
    this.status,
    this.message,
    this.data,
  });

  factory GetOffersResponse.fromJson(Map<String, dynamic> json) =>
      GetOffersResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Offers>.from(json["data"]!.map((x) => Offers.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Offers {
  final int? id;
  final String? title;
  final String? image;

  Offers({
    this.id,
    this.title,
    this.image,
  });

  factory Offers.fromJson(Map<String, dynamic> json) => Offers(
        id: int.tryParse(json["id"]),
        title: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
      };
}
