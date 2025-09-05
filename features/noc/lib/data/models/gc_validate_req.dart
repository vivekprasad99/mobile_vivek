class GcValidateReq {
  final String? loanAccountNumber;

  GcValidateReq({
    this.loanAccountNumber,
  });

  factory GcValidateReq.fromJson(Map<String, dynamic> json) => GcValidateReq(
        loanAccountNumber: json["loanAccountNumber"],
      );

  Map<String, dynamic> toJson() => {
        "loanAccountNumber": loanAccountNumber,
      };
}
