class UpdateRcDetailsReq {
  final String? rcNumber;
  final String? loanNumber;
  // final String? customerNo;
  // final String? chasisNo;
  // final String? vehicleEngineNo;
  // final bool? isFinancerMatched;
  final String sourceSystem;

  UpdateRcDetailsReq({
    this.rcNumber,
    this.loanNumber,
    // this.customerNo,
    // this.chasisNo,
    // this.vehicleEngineNo,
    // this.isFinancerMatched,
    required this.sourceSystem,
  });

  factory UpdateRcDetailsReq.fromJson(Map<String, dynamic> json) =>
      UpdateRcDetailsReq(
        rcNumber: json["rc_number"],
        loanNumber: json["loan_number"],
        // customerNo: json["customer_no"],
        // chasisNo: json["chasis_no"],
        // vehicleEngineNo: json["vehicle_engine_no"],
        // isFinancerMatched: json["isFinancerMatched"],
        sourceSystem: json['sourceSystem'],
      );

  Map<String, dynamic> toJson() => {
        "rc_number": rcNumber,
        "loan_number": loanNumber,
        // "customer_no": customerNo,
        // "chasis_no": chasisNo,
        // "vehicle_engine_no": vehicleEngineNo,
        // "isFinancerMatched": isFinancerMatched,
        "sourceSystem": sourceSystem,
      };
}
