class GetAchLoansResponse {
  String? code;
  String? message;
  List<LoanData>? data;
  String? responseCode;

  GetAchLoansResponse({this.code, this.message, this.data, this.responseCode});

  GetAchLoansResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    responseCode = json['responseCode'];
    if (json['data'] != null) {
      data = <LoanData>[];
      json['data'].forEach((v) {
        data!.add(LoanData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['responseCode'] = responseCode;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LoanData {
  String? ucic;
  String? cif;
  String? coApplicantCIF;
  String? branchId;
  String? loanAccountNumber;
  double? totalAmount;
  double? totalPendingAmount;
  double? interestRate;
  double? installmentAmount;
  double? excessAmount;
  String? startDate;
  String? endDate;
  String? nextDuedate;
  String? loanStatus;
  int? dpd;
  String? lob;
  String? productName;
  String? vehicleRegistration;
  String? sourceSystem;
  String? productCategory;
  String? applicantName;
  String? coApplicantName;
  String? mandateStatus;
  String? nocStatus;
  int? loanTenure;
  int? totalEmiPaid;
  String? totalAmountOverdue;
  String? mobileNumber;

  LoanData(
      {this.ucic,
      this.cif,
      this.coApplicantCIF,
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
      this.productName,
      this.vehicleRegistration,
      this.sourceSystem,
      this.productCategory,
      this.applicantName,
      this.coApplicantName,
      this.mandateStatus,
      this.nocStatus,
      this.loanTenure,
      this.totalEmiPaid,
      this.totalAmountOverdue,
      this.mobileNumber});

  LoanData.fromJson(Map<String, dynamic> json) {
    ucic = json['ucic'];
    cif = json['cif'];
    coApplicantCIF = json['coApplicantCIF'];
    branchId = json['branchId'];
    loanAccountNumber = json['loanAccountNumber'];
    totalAmount = json['totalAmount'] ?? 0.0;
    totalPendingAmount = json['totalPendingAmount'] ?? 0.0;
    interestRate = json['interestRate'];
    installmentAmount = json['installmentAmount'] ?? 0.0;
    excessAmount = json['excessAmount'] ?? 0.0;
    startDate = json['startDate'];
    endDate = json['endDate'];
    nextDuedate = json['nextDuedate'];
    loanStatus = json['loanStatus'];
    dpd = json['dpd'];
    lob = json['lob'] ?? json["LOB"] ?? "";
    productName = json['productName'];
    vehicleRegistration = json['vehicleRegistration'];
    sourceSystem = json['sourceSystem'];
    productCategory = json['productCategory'];
    applicantName = json['applicantName'];
    coApplicantName = json['coApplicantName'];
    mandateStatus = json['mandateStatus'];
    nocStatus = json['nocStatus'];
    loanTenure = json['loanTenure'] ?? 0.0;
    totalEmiPaid = json['totalEmiPaid'] ?? 0.0;
    totalAmountOverdue = json['totalAmountOverdue'].toString();
    mobileNumber = json["mobileNumber"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ucic'] = ucic;
    data['cif'] = cif;
    data['coApplicantCIF'] = coApplicantCIF;
    data['branchId'] = branchId;
    data['loanAccountNumber'] = loanAccountNumber;
    data['totalAmount'] = totalAmount ?? 0.0;
    data['totalPendingAmount'] = totalPendingAmount ?? 0.0;
    data['interestRate'] = interestRate;
    data['installmentAmount'] = installmentAmount ?? 0.0;
    data['excessAmount'] = excessAmount ?? 0.0;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['nextDuedate'] = nextDuedate;
    data['loanStatus'] = loanStatus;
    data['dpd'] = dpd;
    data['lob'] = lob;
    data['productName'] = productName;
    data['vehicleRegistration'] = vehicleRegistration;
    data['sourceSystem'] = sourceSystem;
    data['productCategory'] = productCategory;
    data['applicantName'] = applicantName;
    data['co-ApplicantName'] = coApplicantName;
    data['mandateStatus'] = mandateStatus;
    data['nocStatus'] = nocStatus;
    data['loanTenure'] = loanTenure ?? 0.0;
    data['totalEmiPaid'] = totalEmiPaid ?? 0.0;
    data['totalAmountOverdue'] = totalAmountOverdue ?? 0.0;
    data['mobileNumber'] = mobileNumber;
    return data;
  }
}
