class GetMakeModelReq {
  final String assetClass;

  GetMakeModelReq({
    required this.assetClass,
  });

  factory GetMakeModelReq.fromJson(Map<String, dynamic> json) =>
      GetMakeModelReq(
        assetClass: json["assetClass"],
      );

  Map<String, dynamic> toJson() => {
        "assetClass": assetClass,
      };
}
