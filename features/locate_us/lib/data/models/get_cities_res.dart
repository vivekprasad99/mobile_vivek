class GetCitiesResponse {
  final String? code;
  final String? message;
  final String? responseCode;
  final List<City>? cityList;

  GetCitiesResponse({
    this.code,
    this.message,
    this.responseCode,
    this.cityList,
  });

  factory GetCitiesResponse.fromJson(Map<String, dynamic> json) =>
      GetCitiesResponse(
        code: json["code"],
        message: json["message"],
        responseCode: json["responseCode"],
        cityList: json["cityList"] == null
            ? []
            : List<City>.from(json["cityList"]!.map((x) => City.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "responseCode": responseCode,
        "cityList": cityList == null
            ? []
            : List<dynamic>.from(cityList!.map((x) => x.toJson())),
      };
}

class City {
  final int? cityCode;
  final String? cityName;

  City({
    this.cityCode,
    this.cityName,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        cityCode: json["cityCode"],
        cityName: json["cityName"],
      );

  Map<String, dynamic> toJson() => {
        "cityCode": cityCode,
        "cityName": cityName,
      };
}
