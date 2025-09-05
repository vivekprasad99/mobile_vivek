class NocServiceReqParams {
  final String? loanAccountNumber;
  final String? lob;
  final String? mobileNumber;
  final String? productName;
  final int caseType;
  final String? sourceSystem;
  final String? productCategory;
  final String? srType;

  NocServiceReqParams({
    required this.loanAccountNumber,
    required this.lob,
    required this.mobileNumber,
    required this.productName,
    required this.sourceSystem,
    required this.productCategory,
    required this.srType,
    required this.caseType,
  });
}
