class GetCitiesRequest {
  final int stateCode;

  GetCitiesRequest({
    required this.stateCode,
  });

  factory GetCitiesRequest.fromJson(Map<String, dynamic> json) =>
      GetCitiesRequest(
        stateCode: json["stateCode"],
      );

  Map<String, dynamic> toJson() => {
        "stateCode": stateCode,
      };
}
