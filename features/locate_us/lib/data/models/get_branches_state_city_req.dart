class GetBranchesStateCityRequest {
  final int stateCode;
  final int cityCode;
  final bool isDealers;
  final bool onlyDealers;

  GetBranchesStateCityRequest({
    required this.stateCode,
    required this.cityCode,
    this.isDealers = false,
    this.onlyDealers = false,
  });

  factory GetBranchesStateCityRequest.fromJson(Map<String, dynamic> json) =>
      GetBranchesStateCityRequest(
        stateCode: json["stateCode"],
        cityCode: json["cityCode"],
      );

  Map<String, dynamic> toJson() => {
        "stateCode": stateCode,
        "cityCode": cityCode,
      };

  GetBranchesStateCityRequest copyWith({
    int? stateCode,
    int? cityCode,
    bool? isDealers,
    bool? onlyDealers,
  }) =>
      GetBranchesStateCityRequest(
        stateCode: stateCode ?? this.stateCode,
        cityCode: cityCode ?? this.cityCode,
        isDealers: isDealers ?? this.isDealers,
        onlyDealers: onlyDealers ?? this.onlyDealers,
      );
}
