class GetMandateRequest {
  final String? cif;
  final String? loanAccountNumber;
  final String? sourceSystem;
  final String? ucic;
  final String? emiAmount;
  final String? superAppId;
  final String? source;

  GetMandateRequest(
      {this.cif,
      this.loanAccountNumber,
      this.sourceSystem,
      this.ucic,
      this.emiAmount,
      this.superAppId,
      this.source});

  factory GetMandateRequest.fromJson(Map<String, dynamic> json) =>
      GetMandateRequest(
        loanAccountNumber: json["loanAccountNumber"],
        cif: json["cif"],
        sourceSystem: json["sourceSystem"],
        ucic: json["ucic"],
        emiAmount: json["emiAmount"],
        superAppId: json["superAppId"],
        source: json["source"],
      );

  Map<String, dynamic> toJson() => {
        "loanAccountNumber": loanAccountNumber,
        "cif": cif,
        "sourceSystem": sourceSystem,
        "ucic": ucic,
        "emiAmount": emiAmount,
        "superAppId": superAppId,
        "source": source
      };
}
