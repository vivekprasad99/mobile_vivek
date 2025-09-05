class GetStateCityReq {
  final int pinCode;

  GetStateCityReq({
    required this.pinCode,
  });

  factory GetStateCityReq.fromJson(Map<String, dynamic> json) =>
      GetStateCityReq(
        pinCode: json["pinCode"],
      );

  Map<String, dynamic> toJson() => {
        "pinCode": pinCode,
      };
}
