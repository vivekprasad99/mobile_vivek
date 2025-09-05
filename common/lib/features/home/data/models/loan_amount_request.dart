class LoanAmountRequest {
  final String? loanNumber;
  final String? sourceSystem;
   

  LoanAmountRequest({
    this.loanNumber,this.sourceSystem,
  });

  factory LoanAmountRequest.fromJson(Map<String, dynamic> json) =>
      LoanAmountRequest(
        loanNumber: json["loanNumber"],
        sourceSystem: json["sourceSystem"],
      );

  Map<String, dynamic> toJson() => {
        "loanNumber": loanNumber,
        "sourceSystem": sourceSystem,
      };
}
