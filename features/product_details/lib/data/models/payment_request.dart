class PaymentRequest {
  final String? loanNumber;
  final String? sourceSystem;

  PaymentRequest({
    this.loanNumber,
    this.sourceSystem,
  });

  factory PaymentRequest.fromJson(Map<String, dynamic> json) =>
      PaymentRequest(
        loanNumber: json["loanNumber"],
        sourceSystem: json["sourceSystem"],
      );

  Map<String, dynamic> toJson() => {
        "loanNumber": loanNumber,
        "sourceSystem": sourceSystem,
      };
}
