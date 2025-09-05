class GetLoanChargesResponse {
  final String? code;

  final double? totalCharges;

  GetLoanChargesResponse({
    this.code,
    this.totalCharges,
  });

  factory GetLoanChargesResponse.fromJson(Map<String, dynamic> json) =>
      GetLoanChargesResponse(
        code: json["code"],
        totalCharges: json["totalCharges"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "totalCharges": totalCharges,
      };
}
