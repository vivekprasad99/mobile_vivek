class NocDetailsReq {
  final String? loanNumber;
  final String? productCategory;
  final String? productName;
  final String? ucic;
  final String? endDate;
  final String? mobileNumber;
  final String? lob;
  final String? sourceSystem;
  final String? nocStatus;
  final bool containsRc;
  NocDetailsReq({
    this.loanNumber,
    this.productCategory,
    this.productName,
    this.ucic,
    this.endDate,
    this.mobileNumber,
    this.lob,
    this.sourceSystem,
    required this.nocStatus,
    required this.containsRc,
  });

  factory NocDetailsReq.fromJson(Map<String, dynamic> json) => NocDetailsReq(
        loanNumber: json["loan_number"],
        productCategory: json["productCategory"],
        productName: json["productName"],
        ucic: json["ucic"],
        endDate: json["endDate"],
        mobileNumber: json["mobileNumber"],
        lob: json["lob"],
        sourceSystem: json["sourceSystem"],
        nocStatus: json["nocStatus"],
        containsRc: false,
      );

  Map<String, dynamic> toJson() => {
        "loan_number": loanNumber,
        "productCategory": productCategory,
        "productName": productName,
        "ucic": ucic,
        "endDate": endDate,
        "mobileNumber": mobileNumber,
        "lob": lob,
        "sourceSystem": sourceSystem,
        "nocStatus": nocStatus,
      };
}
