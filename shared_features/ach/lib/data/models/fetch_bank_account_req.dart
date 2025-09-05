class FetchBankAccountRequest {
  final String? loanAccountNumber;
  final String? ucic;
  final String? cif;
  final String? superAppId;
  final String? source;

  FetchBankAccountRequest({
    this.loanAccountNumber,
    this.ucic,
    this.cif,
    this.source,
    this.superAppId
  });

  factory FetchBankAccountRequest.fromJson(Map<String, dynamic> json) =>
      FetchBankAccountRequest(
        loanAccountNumber: json["loanAccountNumber"],
        ucic: json["ucic"],
        cif: json["cif"],
        source: json["source"],
        superAppId: json["superAppId"],
      );

  Map<String, dynamic> toJson() => {
        "loanAccountNumber": loanAccountNumber,
        "ucic": ucic,
        "cif": cif,
        "source": source,
        "superAppId": superAppId
      };
}
