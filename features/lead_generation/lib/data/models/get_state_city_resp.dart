class GetStateCityResp {
  final String code;
  final String message;
  final String responseCode;
  final List<StateCityList> stateCityList;

  GetStateCityResp({
    required this.code,
    required this.message,
    required this.responseCode,
    required this.stateCityList,
  });

  factory GetStateCityResp.fromJson(Map<String, dynamic> json) =>
      GetStateCityResp(
        code: json["code"],
        message: json["message"],
        responseCode: json["responseCode"],
        stateCityList: json["stateCityList"] != null
            ? List<StateCityList>.from(
                json["stateCityList"].map((x) => StateCityList.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "responseCode": responseCode,
        "stateCityList":
            List<dynamic>.from(stateCityList.map((x) => x.toJson())),
      };
}

class StateCityList {
  final int stateCode;
  final String stateName;
  final int cityCode;
  final String cityName;

  StateCityList({
    required this.stateCode,
    required this.stateName,
    required this.cityCode,
    required this.cityName,
  });

  factory StateCityList.fromJson(Map<String, dynamic> json) => StateCityList(
        stateCode: json["stateCode"],
        stateName: json["stateName"],
        cityCode: json["cityCode"],
        cityName: json["cityName"],
      );

  Map<String, dynamic> toJson() => {
        "stateCode": stateCode,
        "stateName": stateName,
        "cityCode": cityCode,
        "cityName": cityName,
      };
}
