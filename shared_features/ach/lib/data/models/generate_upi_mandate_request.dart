class GenerateUpiMandateRequest {
  final double? amount;
  final String? mandatestartdate;
  final String? mandateenddate;
  final String? payername;
  final String? payervpa;
  final String? pattern;
  final String? revokeable;
  final String? ifsc;
  final String? loanAccountNumber;
  final String? trxnno;
  final String? productName;
  final String? sourceSystem;
  final String? loanNumber;
  final bool? updateRequest;
  final String? mandateId;
  final String? batchNumber;
  final String? updateReason;
  final String? authorize;
  final String? authorizerevoke;
  final String? superAppId;
  final String? source;

  GenerateUpiMandateRequest({
    this.amount,
    this.mandatestartdate,
    this.mandateenddate,
    this.payername,
    this.payervpa,
    this.pattern,
    this.revokeable,
    this.ifsc,
    this.loanAccountNumber,
    this.trxnno,
    this.productName,
    this.sourceSystem,
    this.loanNumber,
    this.updateRequest,
    this.mandateId,
    this.batchNumber,
    this.updateReason,
    this.authorize,
    this.authorizerevoke,
    this.source,
    this.superAppId
  });

  factory GenerateUpiMandateRequest.fromJson(Map<String, dynamic> json) =>
      GenerateUpiMandateRequest(
        amount: json["amount"],
        mandatestartdate: json["mandatestartdate"],
        mandateenddate: json["mandateenddate"],
        payername: json["payername"],
        payervpa: json["payervpa"],
        pattern: json["pattern"],
        revokeable: json["revokeable"],
        ifsc: json["ifsc"],
        loanAccountNumber: json["loanAccountNumber"],
        trxnno: json["trxnno"],
        productName: json["product_name"],
        sourceSystem: json["sourceSystem"],
        loanNumber: json["loanNumber"],
        updateRequest: json["updateRequest"],
        mandateId: json["mandateId"],
        batchNumber: json["batchNumber"],
        updateReason: json["updateReason"],
        authorize: json["trxnno"],
        authorizerevoke: json["trxnno"],
        source: json["source"],
        superAppId: json["superAppId"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "mandatestartdate": mandatestartdate,
        "mandateenddate": mandateenddate,
        "payername": payername,
        "payervpa": payervpa,
        "pattern": pattern,
        "revokeable": revokeable,
        "ifsc": ifsc,
        "loanAccountNumber": loanAccountNumber,
        "trxnno": trxnno,
        "product_name": productName,
        "sourceSystem": sourceSystem,
        "loanNumber": loanNumber,
        "updateRequest": updateRequest,
        "mandateId": mandateId,
        "batchNumber": batchNumber,
        "updateReason": updateReason,
        "authorize": authorize,
        "authorizerevoke": authorizerevoke,
        "source": source,
        "superAppId": superAppId,
      };
}
