class GetBranchesPincodeRequest {
  final String pincode;
  final bool isDealers;
  final bool onlyDealers;

  GetBranchesPincodeRequest({
    required this.pincode,
    this.isDealers = false,
    this.onlyDealers = false,
  });

  factory GetBranchesPincodeRequest.fromJson(Map<String, dynamic> json) =>
      GetBranchesPincodeRequest(
        pincode: json["pinCode"],
      );

  Map<String, dynamic> toJson() => {
        "pinCode": pincode,
      };

  GetBranchesPincodeRequest copyWith({
    String? pincode,
    bool? isDealers,
    bool? onlyDealers,
  }) =>
      GetBranchesPincodeRequest(
        pincode: pincode ?? this.pincode,
        isDealers: isDealers ?? this.isDealers,
        onlyDealers: onlyDealers ?? this.onlyDealers,
      );
}
