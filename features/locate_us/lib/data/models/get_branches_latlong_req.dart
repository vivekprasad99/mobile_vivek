class GetBranchesLatLongRequest {
  final double? lat;
  final double? lon;

  GetBranchesLatLongRequest({
    this.lat,
    this.lon,
  });

  factory GetBranchesLatLongRequest.fromJson(Map<String, dynamic> json) =>
      GetBranchesLatLongRequest(
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lon": lon,
      };

  GetBranchesLatLongRequest copyWith({
    double? lat,
    double? lon,
  }) =>
      GetBranchesLatLongRequest(
        lat: lat ?? this.lat,
        lon: lon ?? this.lon,
      );
}
