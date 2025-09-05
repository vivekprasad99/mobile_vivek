class GetBranchesResponse {
  final String? code;
  final String? message;
  final String? responseCode;
  final List<Branch>? branchList;

  GetBranchesResponse({
    this.code,
    this.message,
    this.responseCode,
    this.branchList,
  });

  factory GetBranchesResponse.fromJson(Map<String, dynamic> json) =>
      GetBranchesResponse(
        code: json["code"],
        message: json["message"],
        responseCode: json["responseCode"],
        branchList: json["branchList"] == null
            ? []
            : List<Branch>.from(
                json["branchList"]!.map(
                  (x) => Branch.fromJson(
                    x,
                    codePrefix: 'B-',
                  ),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "responseCode": responseCode,
        "branchList": branchList == null
            ? []
            : List<dynamic>.from(branchList!.map((x) => x.toJson())),
      };

  factory GetBranchesResponse.fromDealerJson(Map<String, dynamic> json) =>
      GetBranchesResponse(
        code: json["code"],
        message: json["message"],
        responseCode: json["responseCode"],
        branchList: json["dealerList"] == null
            ? []
            : List<Branch>.from(
                json["dealerList"]!.map(
                  (x) => Branch.fromJson(
                    x,
                    codePrefix: 'D-',
                  ),
                ),
              ),
      );

  Map<String, dynamic> toDealerJson() => {
        "code": code,
        "message": message,
        "responseCode": responseCode,
        "dealerList": branchList == null
            ? []
            : List<dynamic>.from(branchList!.map((x) => x.toJson())),
      };

  GetBranchesResponse copyWith({
    String? code,
    String? message,
    String? responseCode,
    List<Branch>? branchList,
  }) =>
      GetBranchesResponse(
        code: code ?? this.code,
        message: message ?? this.message,
        responseCode: responseCode ?? this.responseCode,
        branchList: branchList ?? this.branchList,
      );
}

class Branch {
  final String? code;
  final String? name;
  final String? address;
  final double? lat;
  final double? lon;
  final String? location;
  final String? number;
  final double? distance;

  Branch({
    this.code,
    this.name,
    this.address,
    this.lat,
    this.lon,
    this.location,
    this.number,
    this.distance,
  });
  factory Branch.fromJson(
    Map<String, dynamic> json, {
    required String codePrefix,
  }) =>
      Branch(
        code: "$codePrefix${json["code"]}",
        name: json["name"],
        address: json["address"],
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
        location: json["location"],
        number: json["mobileNo"],
        distance: json["distance"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "address": address,
        "lat": lat,
        "lon": lon,
        "location": location,
        "mobileNo": number,
        "distance": distance,
      };

  Branch copyWith({
    String? code,
    String? name,
    String? address,
    double? lat,
    double? lon,
    String? location,
    String? number,
    double? distance,
  }) =>
      Branch(
        code: code ?? this.code,
        name: name ?? this.name,
        address: address ?? this.address,
        lat: lat ?? this.lat,
        lon: lon ?? this.lon,
        location: location ?? this.location,
        number: number ?? this.number,
        distance: distance ?? this.distance,
      );
}
