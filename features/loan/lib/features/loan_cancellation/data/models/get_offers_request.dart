class GetOffersRequest {
  final String? loanAccountNumber;
  final String? customerId;
  final String? sourceSystem;
  final String? productcode;
  final int? offerId;

  GetOffersRequest({
    this.loanAccountNumber,
    this.customerId,
    this.sourceSystem,
    this.productcode,
    this.offerId,
  });

  factory GetOffersRequest.fromJson(Map<String, dynamic> json) =>
      GetOffersRequest(
        loanAccountNumber: json["loanAccountNumber"],
        customerId: json["CustomerId"],
        sourceSystem: json["sourceSystem"],
        productcode: json["productcode"],
        offerId: json["offerId"],
      );

  Map<String, dynamic> toJson() => {
        "loanAccountNumber": loanAccountNumber,
        "CustomerId": customerId,
        "sourceSystem": sourceSystem,
        "productcode": productcode,
        "offerId": offerId,
      };
}
