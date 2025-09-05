class PennyDropReq {
  final String? beneficiaryAccount;
  final String? beneficiaryIFSC;
  final String? loanAccountNumber;
  final String? ucic;
  final String? verificationMode;
  final String? accountType;
  final String? customerName;
  final String? mobileNumber;
  final String? superAppId;
  final String? source;

  PennyDropReq({
    this.beneficiaryAccount,
    this.beneficiaryIFSC,
    this.loanAccountNumber,
    this.ucic,
    this.verificationMode,
    this.accountType,
    this.customerName,
    this.mobileNumber,
    this.superAppId,
    this.source,
  });

  factory PennyDropReq.fromJson(Map<String, dynamic> json) => PennyDropReq(
        beneficiaryAccount: json["beneficiaryAccount"],
        beneficiaryIFSC: json["beneficiaryIFSC"],
        loanAccountNumber: json["loanAccountNumber"],
        ucic: json["UCIC"],
        verificationMode: json["verification_mode"],
        accountType: json["accountType"],
        customerName: json["customerName"],
        mobileNumber: json["mobileNumber"],
        superAppId: json["superAppId"],
        source: json["source"],
      );

  Map<String, dynamic> toJson() => {
        "beneficiaryAccount": beneficiaryAccount,
        "beneficiaryIFSC": beneficiaryIFSC,
        "loanAccountNumber": loanAccountNumber,
        "UCIC": ucic,
        "verification_mode": verificationMode,
        "accountType": accountType,
        "customerName": customerName,
        "mobileNumber": mobileNumber,
        "superAppId": superAppId,
        "source": source,
      };
}
