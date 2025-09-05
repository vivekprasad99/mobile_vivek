class GetLoanChargesRequest {
  final String? loanAccountNumber;

  GetLoanChargesRequest({
    this.loanAccountNumber,
  });

  factory GetLoanChargesRequest.fromJson(Map<String, dynamic> json) =>
      GetLoanChargesRequest(
        loanAccountNumber: json["loanAccountNumber"],
      );

  Map<String, dynamic> toJson() => {
        "loanAccountNumber": loanAccountNumber,
      };
}
