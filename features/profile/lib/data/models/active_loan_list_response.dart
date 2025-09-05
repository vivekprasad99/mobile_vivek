class ActiveLoanListResponse {
  String? code;
  String? message;
  String? responseCode;
  List<ActiveLoanData>? loanList;

  ActiveLoanListResponse({
    this.code,
    this.message,
    this.loanList,
    this.responseCode,
  });

  factory ActiveLoanListResponse.fromJson(Map<String, dynamic> json) =>
      ActiveLoanListResponse(
        code: json["code"],
        loanList: json["data"] == null
            ? []
            : List<ActiveLoanData>.from(
                json["data"]!.map((x) => ActiveLoanData.fromJson(x))),
        message: json["message"],
        responseCode: json['responseCode'] == null
            ? null
            : json['responseCode'] as String,
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": loanList == null
            ? []
            : List<dynamic>.from(loanList!.map((x) => x.toJson())),
        "message": message,
        'responseCode': responseCode,
      };
}

class ActiveLoanData {
  final String? ucic;
  final String? tenantId;
  final String? cif;
  final String? coApplicantCif;
  final String? branchId;
  final String? loanStatus;
  final String? productCategory;
  final String? productName;
  final String? lob;
  final double? installmentAmount;
  final String? nextDuedate;
  final String? loanNumber;
  final double? totalAmountOverdue;
  final double? totalOutstandingAmount;
  final double? totalPenaltyAmount;
  final double? totalBounceCharge;
  final double? interestRate;
  final String? nocStatus;
  final String? mandateStatus;
  final String? startDate;
  final String? endDate;
  final String? vehicleRegistration;
  final String? flgAvailabilityFlag;
  final String? dpd;
  final double? excessAmount;
  final String? mobileNumber;
  final String? sourceSystem;
  double? totalPayableAmount;
  final double? totalAmount;
  final String? docFlag;

  ActiveLoanData({
    this.ucic,
    this.tenantId,
    this.cif,
    this.coApplicantCif,
    this.branchId,
    this.loanStatus,
    this.productCategory,
    this.productName,
    this.lob,
    this.installmentAmount,
    this.nextDuedate,
    this.loanNumber,
    this.totalAmountOverdue,
    this.totalOutstandingAmount,
    this.totalPenaltyAmount,
    this.totalBounceCharge,
    this.interestRate,
    this.nocStatus,
    this.mandateStatus,
    this.startDate,
    this.endDate,
    this.vehicleRegistration,
    this.flgAvailabilityFlag,
    this.dpd,
    this.excessAmount,
    this.mobileNumber,
    this.sourceSystem,
    this.totalPayableAmount,
    this.totalAmount,
    this.docFlag,
  });

  factory ActiveLoanData.fromJson(Map<String, dynamic> json) => ActiveLoanData(
        ucic: json["ucic"] ?? "",
        tenantId: json["tenantID"] ?? "",
        cif: json["cif"] ?? "",
        coApplicantCif: json["coApplicantCIF"] ?? "",
        branchId: json["branchID"] ?? "",
        loanStatus: json["loanStatus"] ?? "",
        productCategory: json["productCategory"] ?? "",
        productName: json["productName"] ?? "",
        lob: json["LOB"] ?? "",
        installmentAmount: json["installmentAmount"] ?? 0.0,
        nextDuedate: json["nextDuedate"] ?? "",
        loanNumber: json["loanAccountNumber"] ?? "",
        totalAmountOverdue:
            double.parse(json["totalAmountOverdue"].toString()),
        totalOutstandingAmount: json["totalOutstandingAmount"] ?? 0.0,
        totalPenaltyAmount: json["totalPenaltyAmount"] ?? 0.0,
        totalBounceCharge: json["totalBounceCharge"] ?? 0.0,
        interestRate: json["interestRate"] ?? 0,
        nocStatus: json["nocStatus"] ?? "",
        mandateStatus: json["mandateStatus"] ?? "",
        startDate: json["startDate"] ?? "",
        endDate: json["endDate"] ?? "",
        vehicleRegistration: json["vehicleRegistration"] ?? "",
        flgAvailabilityFlag: json["flgAvailabilityFlag"] ?? "",
        dpd: json["DPD"] ?? "",
        excessAmount: json["excessAmount"] ?? 0.0,
        mobileNumber: json["mobileNumber"] ?? "",
        sourceSystem: json["sourceSystem"] ?? "",
        totalAmount: json["totalAmount"] ?? 0.0,
        docFlag: json["docFlag"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "ucic": ucic,
        "tenantID": tenantId,
        "cif": cif,
        "coApplicantCIF": coApplicantCif,
        "branchID": branchId,
        "loanStatus": loanStatus,
        "productCategory": productCategory,
        "productName": productName,
        "LOB": lob,
        "installmentAmount": installmentAmount,
        "nextDuedate": nextDuedate,
        "loanAccountNumber": loanNumber,
        "totalAmountOverdue": totalAmountOverdue,
        "totalOutstandingAmount": totalOutstandingAmount,
        "totalPenaltyAmount": totalPenaltyAmount,
        "totalBounceCharge": totalBounceCharge,
        "interestRate": interestRate,
        "nocStatus": nocStatus,
        "mandateStatus": mandateStatus,
        "startDate": startDate,
        "endDate": endDate,
        "vehicleRegistration": vehicleRegistration,
        "flgAvailabilityFlag": flgAvailabilityFlag,
        "DPD": dpd,
        "excessAmount": excessAmount,
        "mobileNumber": mobileNumber,
        "sourceSystem": sourceSystem,
        "totalAmount": totalAmount,
        "docFlag": docFlag,
      };
}
