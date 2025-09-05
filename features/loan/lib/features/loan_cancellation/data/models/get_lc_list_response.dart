class GetLoanCancellationResponse {
  final String? code;
  final String? message;
  final String? responseCode;
  final List<LoanCancelItem>? data;

  GetLoanCancellationResponse({
    this.code,
    this.message,
    this.responseCode,
    this.data,
  });

  factory GetLoanCancellationResponse.fromJson(Map<String, dynamic> json) =>
      GetLoanCancellationResponse(
        code: json["code"],
        message: json["message"],
        responseCode: json["responseCode"],
        data: json["data"] == null
            ? []
            : List<LoanCancelItem>.from(
                json["data"]!.map((x) => LoanCancelItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "responseCode": responseCode,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class LoanCancelItem {
  final String? ucic;
  final dynamic mobileNumber;
  final dynamic tenantId;
  final String? cif;
  final String? coApplicantCif;
  final String? applicantName;
  final String? coApplicantName;
  final String? branchId;
  final String? loanAccountNumber;
  final double? totalAmount;
  final double? totalPendingAmount;
  final double? interestRate;
  final double? installmentAmount;
  final double? excessAmount;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? nextDuedate;
  final String? loanStatus;
  final int? dpd;
  final String? lob;
  final String? nocStatus;
  final String? mandateStatus;
  final String? productName;
  final String? vehicleRegistration;
  final String? sourceSystem;
  final String? productCategory;

  LoanCancelItem({
    this.ucic,
    this.mobileNumber,
    this.tenantId,
    this.cif,
    this.coApplicantCif,
    this.applicantName,
    this.coApplicantName,
    this.branchId,
    this.loanAccountNumber,
    this.totalAmount,
    this.totalPendingAmount,
    this.interestRate,
    this.installmentAmount,
    this.excessAmount,
    this.startDate,
    this.endDate,
    this.nextDuedate,
    this.loanStatus,
    this.dpd,
    this.lob,
    this.nocStatus,
    this.mandateStatus,
    this.productName,
    this.vehicleRegistration,
    this.sourceSystem,
    this.productCategory,
  });

  factory LoanCancelItem.fromJson(Map<String, dynamic> json) => LoanCancelItem(
        ucic: json["ucic"],
        mobileNumber: json["mobileNumber"],
        tenantId: json["tenantId"],
        cif: json["cif"],
        coApplicantCif: json["coApplicantCIF"],
        applicantName: json["applicantName"],
        coApplicantName: json["coApplicantName"],
        branchId: json["branchId"],
        loanAccountNumber: json["loanAccountNumber"],
        totalAmount: json["totalAmount"],
        totalPendingAmount: json["totalPendingAmount"],
        interestRate: json["interestRate"],
        installmentAmount: json["installmentAmount"],
        excessAmount: json["excessAmount"],
        startDate: json["startDate"] == null
            ? null
            : DateTime.parse(json["startDate"]),
        endDate:
            json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        nextDuedate: json["nextDuedate"] == null
            ? null
            : DateTime.parse(json["nextDuedate"]),
        loanStatus: json["loanStatus"],
        dpd: json["dpd"],
        lob: json["lob"],
        nocStatus: json["nocStatus"],
        mandateStatus: json["mandateStatus"],
        productName: json["productName"],
        vehicleRegistration: json["vehicleRegistration"],
        sourceSystem: json["sourceSystem"],
        productCategory: json["productCategory"],
      );

  Map<String, dynamic> toJson() => {
        "ucic": ucic,
        "mobileNumber": mobileNumber,
        "tenantId": tenantId,
        "cif": cif,
        "coApplicantCIF": coApplicantCif,
        "applicantName": applicantName,
        "coApplicantName": coApplicantName,
        "branchId": branchId,
        "loanAccountNumber": loanAccountNumber,
        "totalAmount": totalAmount,
        "totalPendingAmount": totalPendingAmount,
        "interestRate": interestRate,
        "installmentAmount": installmentAmount,
        "excessAmount": excessAmount,
        "startDate":
            "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "endDate":
            "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
        "nextDuedate":
            "${nextDuedate!.year.toString().padLeft(4, '0')}-${nextDuedate!.month.toString().padLeft(2, '0')}-${nextDuedate!.day.toString().padLeft(2, '0')}",
        "loanStatus": loanStatus,
        "dpd": dpd,
        "lob": lob,
        "nocStatus": nocStatus,
        "mandateStatus": mandateStatus,
        "productName": productName,
        "vehicleRegistration": vehicleRegistration,
        "sourceSystem": sourceSystem,
        "productCategory": productCategory,
      };
}
