class GetDealerReq {
  final int assetCode;

  GetDealerReq({
    required this.assetCode,
  });

  factory GetDealerReq.fromJson(Map<String, dynamic> json) => GetDealerReq(
        assetCode: json["assetCode"],
      );

  Map<String, dynamic> toJson() => {
        "assetCode": assetCode,
      };
}
