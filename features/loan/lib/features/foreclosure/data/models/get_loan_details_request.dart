class GetLoanDetailsRequest {
  final String? ucic;
  final String? loanNumber;
  final String? sourceSystem;
  final String? productCategory;

  GetLoanDetailsRequest({
    this.ucic,
    this.loanNumber,
    this.sourceSystem,
    this.productCategory
  });

  factory GetLoanDetailsRequest.fromJson(Map<String, dynamic> json) =>
      GetLoanDetailsRequest(
        ucic: json["ucic"],
        loanNumber: json["loanNumber"],
        sourceSystem: json["sourceSystem"],
        productCategory: json["productCategory"]
      );

  Map<String, dynamic> toJson() => {
        "ucic": ucic,
        "loanNumber": loanNumber,
        "sourceSystem": sourceSystem,
        "productCategory": productCategory
      };
}
