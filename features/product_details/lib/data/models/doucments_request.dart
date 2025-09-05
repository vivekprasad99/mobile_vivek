class DocumentsRequest {
  final String? loanNumber;
  final String? sourceSystem;
  final String? docFlag;
  final String? empCode;

  DocumentsRequest({
    this.loanNumber,
    this.sourceSystem,
    this.docFlag,
    this.empCode,
  });

  factory DocumentsRequest.fromJson(Map<String, dynamic> json) =>
      DocumentsRequest(
        loanNumber: json["loanNumber"],
        sourceSystem: json["sourceSystem"],
        docFlag: json["docFlag"],
        empCode: json["empCode"],
      );

  Map<String, dynamic> toJson() => {
        "loanNumber": loanNumber,
        "sourceSystem": sourceSystem,
        "docFlag": docFlag,
        "empCode": empCode,
      };
}
