class GetLoansResponse {
  final String? code;
  final String? message;
  final List<LoanItem>? data;

  GetLoansResponse({
    this.code,
    this.message,
    this.data,
  });

  factory GetLoansResponse.fromJson(Map<String, dynamic> json) =>
      GetLoansResponse(
        code: json["code"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<LoanItem>.from(
                json["data"]!.map((x) => LoanItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class LoanItem {
  final String? ucic;
  final String? tenantId;
  final String? loanNumber;
  final String? loanAmount;
  final String? totalPendingAmount;
  final String? totalAmount;
  final String? sourceSystem;
  final String? productCategory;
  final String? productName;
  final String? installmentAmount;
  final String? lob;
  final String? mobileNumber;
  final String? vehicleRegistration;
  final String? nextDuedate;
  final String? cif;
  final String? coApplicantCIF;
  final String? startDate;
  final String? endDate;
  final String? loanStatus;
  final int? dpd;
  final String? applicantName;
  final String? coApplicantName;
  final String? mandateStatus;
  final String? nocStatus;
  final double? totalAmountOverdue;


  LoanItem({
    this.ucic,
    this.tenantId,
    this.loanNumber,
    this.loanAmount,
    this.totalPendingAmount,
    this.totalAmount,
    this.sourceSystem,
    this.productCategory,
    this.productName,
    this.installmentAmount,
    this.lob,
    this.mobileNumber,
    this.vehicleRegistration,
    this.nextDuedate,
    this.cif,
    this.coApplicantCIF,
    this.startDate,
    this.endDate,
    this.loanStatus,
    this.dpd,
    this.applicantName,
    this.coApplicantName,
    this.mandateStatus,
    this.nocStatus,
    this.totalAmountOverdue,

  });

  factory LoanItem.fromJson(Map<String, dynamic> json) => LoanItem(
        ucic: json["ucic"],
        tenantId: json["tenantId"],
        loanNumber: json["loanAccountNumber"],
        loanAmount: json["loanAmount"].toString(),
        totalPendingAmount: json["totalPendingAmount"].toString(),
        totalAmount: json["totalAmount"].toString(),
        sourceSystem: json["sourceSystem"],
        productCategory: json["productCategory"],
        productName: json["productName"],
        installmentAmount: json["installmentAmount"].toString(),
        lob: json["lob"].toString(),
        mobileNumber: json["mobileNumber"] ?? "",
        vehicleRegistration: json["vehicleRegistration"] ?? "",
        nextDuedate: json["nextDuedate"] ?? "",
        cif: json["cif"] ?? "",
        coApplicantCIF: json["coApplicantCIF"] ?? "",
        startDate: json["startDate"] ?? "",
        endDate: json["endDate"] ?? "",
        loanStatus: json["loanStatus"] ?? "",
        dpd: json["dpd"] ?? "",
        applicantName: json["applicantName"] ?? "",
        coApplicantName: json["coApplicantName"] ?? "",
        mandateStatus: json["mandateStatus"] ?? "",
        nocStatus: json["nocStatus"] ?? "",
        totalAmountOverdue: json["totalAmountOverdue"] ?? "");

  Map<String, dynamic> toJson() => {
        "ucic": ucic,
        "tenantId": tenantId,
        "loanNumber": loanNumber,
        "loanAmount": loanAmount,
        "totalPendingAmount": totalPendingAmount,
        "totalAmount": totalAmount,
        "sourceSystem": sourceSystem,
        "productCategory": productCategory,
        "productName": productName,
        "installmentAmount" : installmentAmount,
        "lob": lob,
        "mobileNumber": mobileNumber,
        "vehicleRegistration": vehicleRegistration,
        "nextDuedate" : nextDuedate,
        "cif": cif,
        "coApplicantCIF": coApplicantCIF,
        "startDate": startDate,
        "endDate": endDate,
        "loanStatus": loanStatus,
        "dpd": dpd,
        "applicantName": applicantName,
        "coApplicantName": coApplicantName,
        "mandateStatus": mandateStatus,
        "nocStatus": nocStatus,
        "totalAmountOverdue": totalAmountOverdue,
      };
}
