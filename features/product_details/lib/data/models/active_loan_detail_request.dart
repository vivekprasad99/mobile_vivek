class ActiveLoanDetailRequest {
  final String? ucic;
  final String? loanNumber;
  final String? cifId;
  final String? sourceSystem;

  ActiveLoanDetailRequest({
    this.ucic,
    this.loanNumber,
    this.cifId,
    this.sourceSystem,
  });

  factory ActiveLoanDetailRequest.fromJson(Map<String, dynamic> json) =>
      ActiveLoanDetailRequest(
        ucic: json["ucic"],
        loanNumber: json["loanNumber"],
        cifId: json["cifId"],
        sourceSystem: json["sourceSystem"],
      );

  Map<String, dynamic> toJson() => {
        "loanNumber": loanNumber,
        "ucic": ucic,
        "cifId": cifId,
        "sourceSystem": sourceSystem,
      };
}
