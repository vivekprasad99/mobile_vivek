class ActiveLoanDetailResponse {
  String? code;
  String? message;
  final BasicDetailsResponse? basicDetailsResponse;
  final PaymentHistory? paymentHistory;
  final BasicChargeDetails? basicChargeDetails;
  final BasicAssetDetails? basicAssetDetails;
  final BasicCustomerDetails? basicCustomerDetails;
  final BasicBankDetails? bankDetails;
  final BasicMandateDetail? basicMandateDetails;
  final InsuranceDetails? insuranceDetails;
  final RemindersDetails? remindersDetails;
  String? responseCode;
  String? errorCode;

  ActiveLoanDetailResponse({
    this.code,
    this.message,
    this.basicDetailsResponse,
    this.paymentHistory,
    this.basicChargeDetails,
    this.basicAssetDetails,
    this.basicCustomerDetails,
    this.bankDetails,
    this.basicMandateDetails,
    this.insuranceDetails,
    this.remindersDetails,
    this.responseCode,
    this.errorCode,
  });

  bool isBasicBankDetailsEmpty() {
    if (bankDetails == null) {
      return true;
    }
    // Check each field in BasicBankDetails
    return bankDetails!.bankAccHolderName == "-" &&
        bankDetails!.bankAccHolderName!.isEmpty &&
        bankDetails!.bankName == "-" &&
        bankDetails!.bankName!.isEmpty &&
        bankDetails!.branchName == "-" &&
        bankDetails!.branchName!.isEmpty &&
        bankDetails!.bankAccNo == "-" &&
        bankDetails!.bankAccNo!.isEmpty &&
        bankDetails!.umrnNo == "-" &&
        bankDetails!.umrnNo!.isEmpty &&
        bankDetails!.mandateStatus == "-" &&
        bankDetails!.mandateStatus!.isEmpty &&
        bankDetails!.frequency == "-" &&
        bankDetails!.frequency!.isEmpty;
  }

  factory ActiveLoanDetailResponse.fromJson(Map<String, dynamic> json) =>
      ActiveLoanDetailResponse(
        code: json["code"],
        errorCode: json["errorCode"],
        message: json["message"],
        basicDetailsResponse: json["basicDetailsResponse"] == null
            ? null
            : BasicDetailsResponse.fromJson(json["basicDetailsResponse"]),
        paymentHistory: json["paymentHistory"] == null
            ? null
            : PaymentHistory.fromJson(json["paymentHistory"]),
        basicChargeDetails: json["basicChargeDetails"] == null
            ? null
            : BasicChargeDetails.fromJson(json["basicChargeDetails"]),
        basicAssetDetails: json["basicAssetDetails"] == null
            ? null
            : BasicAssetDetails.fromJson(json["basicAssetDetails"]),
        basicCustomerDetails: json["basicCustomerDetails"] == null
            ? null
            : BasicCustomerDetails.fromJson(json["basicCustomerDetails"]),
        bankDetails: json["basicBankDetails"] == null
            ? null
            : BasicBankDetails.fromJson(json["basicBankDetails"]),
        basicMandateDetails: json["basicMandateDetails"] == null
            ? null
            : BasicMandateDetail.fromJson(json["basicMandateDetails"]),
        insuranceDetails: json["basicInsuranceDetails"] == null
            ? null
            : InsuranceDetails.fromJson(json["basicInsuranceDetails"]),
        remindersDetails: json["remindersDetails"] == null
            ? null
            : RemindersDetails.fromJson(json["remindersDetails"]),
        responseCode: json["responseCode"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "errorCode": errorCode,
        "message": message,
        "basicDetailsResponse": basicDetailsResponse?.toJson(),
        "paymentHistory": paymentHistory?.toJson(),
        "basicChargeDetails": basicChargeDetails?.toJson(),
        "basicAssetDetails": basicAssetDetails?.toJson(),
        "basicCustomerDetails": basicCustomerDetails?.toJson(),
        "basicBankDetails": bankDetails?.toJson(),
        "basicMandateDetails": basicMandateDetails?.toJson(),
        "basicInsuranceDetails": insuranceDetails?.toJson(),
        "remindersDetails": remindersDetails?.toJson(),
        "responseCode": responseCode,
      };
}

class Data {
  final BasicDetailsResponse? basicDetailsResponse;
  final PaymentHistory? paymentHistory;
  final BasicChargeDetails? basicChargeDetails;
  final BasicAssetDetails? basicAssetDetails;
  final BasicCustomerDetails? basicCustomerDetails;
  final BasicBankDetails? bankDetails;
  final List<BasicMandateDetail>? basicMandateDetails;
  final InsuranceDetails? insuranceDetails;
  final RemindersDetails? remindersDetails;

  Data({
    this.basicDetailsResponse,
    this.paymentHistory,
    this.basicChargeDetails,
    this.basicAssetDetails,
    this.basicCustomerDetails,
    this.bankDetails,
    this.basicMandateDetails,
    this.insuranceDetails,
    this.remindersDetails,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        basicDetailsResponse: json["basicDetailsResponse"] == null
            ? null
            : BasicDetailsResponse.fromJson(json["basicDetailsResponse"]),
        paymentHistory: json["paymentHistory"] == null
            ? null
            : PaymentHistory.fromJson(json["paymentHistory"]),
        basicChargeDetails: json["basicChargeDetails"] == null
            ? null
            : BasicChargeDetails.fromJson(json["basicChargeDetails"]),
        basicAssetDetails: json["basicAssetDetails"] == null
            ? null
            : BasicAssetDetails.fromJson(json["basicAssetDetails"]),
        basicCustomerDetails: json["basicCustomerDetails"] == null
            ? null
            : BasicCustomerDetails.fromJson(json["basicCustomerDetails"]),
        bankDetails: json["basicBankDetails"] == null
            ? null
            : BasicBankDetails.fromJson(json["basicBankDetails"]),
        basicMandateDetails: json["basicMandateDetails"] == null
            ? []
            : List<BasicMandateDetail>.from(json["basicMandateDetails"]!
                .map((x) => BasicMandateDetail.fromJson(x))),
        insuranceDetails: json["insuranceDetails"] == null
            ? null
            : InsuranceDetails.fromJson(json["insuranceDetails"]),
        remindersDetails: json["remindersDetails"] == null
            ? null
            : RemindersDetails.fromJson(json["remindersDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "basicDetailsResponse": basicDetailsResponse?.toJson(),
        "paymentHistory": paymentHistory?.toJson(),
        "basicChargeDetails": basicChargeDetails?.toJson(),
        "basicAssetDetails": basicAssetDetails?.toJson(),
        "basicCustomerDetails": basicCustomerDetails?.toJson(),
        "basicBankDetails": bankDetails?.toJson(),
        "basicMandateDetails": basicMandateDetails == null
            ? []
            : List<dynamic>.from(basicMandateDetails!.map((x) => x.toJson())),
        "insuranceDetails": insuranceDetails?.toJson(),
        "remindersDetails": remindersDetails?.toJson(),
      };
}

class BasicBankDetails {
  String? bankAccHolderName;
  String? bankName;
  String? branchName;
  String? bankAccNo;
  String? umrnNo;
  String? mandateStatus;
  String? frequency;

  BasicBankDetails(
      {this.bankAccHolderName,
      this.bankName,
      this.branchName,
      this.bankAccNo,
      this.umrnNo,
      this.mandateStatus,
      this.frequency});

  BasicBankDetails.fromJson(Map<String, dynamic> json) {
    bankAccHolderName = json['bankAccHolderName'] ?? "";
    bankName = json['bankName'] ?? "";
    branchName = json['branchName'] ?? "";
    bankAccNo = json['bankAccNo'] ?? "";
    umrnNo = json['umrnNo'];
    mandateStatus = json['mandateStatus'] ?? "";
    frequency = json['frequency'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bankAccHolderName'] = bankAccHolderName;
    data['bankName'] = bankName;
    data['branchName'] = branchName;
    data['bankAccNo'] = bankAccNo;
    data['umrnNo'] = umrnNo;
    data['mandateStatus'] = mandateStatus;
    data['frequency'] = frequency;
    return data;
  }

  bool isEmpty() {
    return bankAccHolderName == "-" ||
        bankAccHolderName!.isEmpty && bankName == "-" ||
        bankName!.isEmpty && branchName == "-" ||
        branchName!.isEmpty && bankAccNo == "-" ||
        bankAccNo!.isEmpty && umrnNo == "-" ||
        umrnNo!.isEmpty && mandateStatus == "-" ||
        mandateStatus!.isEmpty && frequency == "-" ||
        frequency!.isEmpty;
  }
}

class BasicAssetDetails {
  final String? vehicleRegistrationNumber;
  final String? vehicleName;
  final String? engineNumber;
  final String? chasisNumber;

  BasicAssetDetails({
    this.vehicleRegistrationNumber,
    this.vehicleName,
    this.engineNumber,
    this.chasisNumber,
  });

  factory BasicAssetDetails.fromJson(Map<String, dynamic> json) =>
      BasicAssetDetails(
        vehicleRegistrationNumber: json["vehicleRegistrationNumber"],
        vehicleName: json["vehicleName"],
        engineNumber: json["engineNumber"],
        chasisNumber: json["chasisNumber"],
      );

  Map<String, dynamic> toJson() => {
        "vehicleRegistrationNumber": vehicleRegistrationNumber,
        "vehicleName": vehicleName,
        "engineNumber": engineNumber,
        "chasisNumber": chasisNumber,
      };

  bool isEmpty() {
    return vehicleRegistrationNumber == null ||
        vehicleRegistrationNumber!.isEmpty && vehicleName == null ||
        vehicleName!.isEmpty && engineNumber == null ||
        engineNumber!.isEmpty && chasisNumber == null ||
        chasisNumber!.isEmpty;
  }
}

class BasicChargeDetails {
  final String? otherCharges;
  final String? chequeReturnCharges;
  final String? additionalInterestCharges;
  final String? repossessionCharges;

  BasicChargeDetails({
    this.otherCharges,
    this.chequeReturnCharges,
    this.additionalInterestCharges,
    this.repossessionCharges,
  });

  factory BasicChargeDetails.fromJson(Map<String, dynamic> json) =>
      BasicChargeDetails(
        otherCharges: json["otherCharges"] ?? "",
        chequeReturnCharges: json["chequeReturnCharges"] ?? "",
        additionalInterestCharges: json["additionalInterestCharges"] ?? "",
        repossessionCharges: json["repossessionCharges"] ?? "",
      );

  bool isEmptyBasicCharge() {
    return otherCharges == "0" ||
        otherCharges!.isEmpty ||
        chequeReturnCharges == "0" ||
        chequeReturnCharges!.isEmpty ||
        additionalInterestCharges == "0" ||
        additionalInterestCharges!.isEmpty ||
        repossessionCharges == "0" ||
        repossessionCharges!.isEmpty;
  }

  Map<String, dynamic> toJson() => {
        "otherCharges": otherCharges,
        "chequeReturnCharges": chequeReturnCharges,
        "additionalInterestCharges": additionalInterestCharges,
        "repossessionCharges": repossessionCharges,
      };
}

class BasicCustomerDetails {
  final String? customerName;
  final String? coApplicantName;
  final String? guarantorName;
  final String? branch;
  final String? executiveName;
  final String? executiveNumber;

  BasicCustomerDetails({
    this.customerName,
    this.coApplicantName,
    this.guarantorName,
    this.branch,
    this.executiveName,
    this.executiveNumber,
  });

  factory BasicCustomerDetails.fromJson(Map<String, dynamic> json) =>
      BasicCustomerDetails(
        customerName: json["customerName"] ?? "",
        coApplicantName: json["coApllicantName"] ?? "",
        guarantorName: json["guarantorName"] ?? "",
        branch: json["branch"] ?? "",
        executiveName: json["executiveName"] ?? "",
        executiveNumber: json["executiveNumber"] ?? "",
      );

  // bool isEmpty() {
  //   return customerName == null ||
  //       customerName!.isEmpty && coApplicantName == null ||
  //       coApplicantName!.isEmpty && guarantorName == null ||
  //       guarantorName!.isEmpty && branch == null ||
  //       branch!.isEmpty && executiveName == null ||
  //       executiveName!.isEmpty && executiveNumber == null ||
  //       executiveNumber!.isEmpty;
  // }

  Map<String, dynamic> toJson() => {
        "coApplicantName": coApplicantName,
        "guarantorName": guarantorName,
        "branch": branch,
        "executiveName": executiveName,
        "executiveNumber": executiveNumber,
      };
}

class BasicDetailsResponse {
  String? financedAmount;
  String? loanId;
  String? loanNumber;
  String? vehicleRegistrationNumber;
  String? totalOutstandingAmount;
  String? startDate;
  String? endDate;
  String? loanTenure;
  String? status;
  String? numberOfPaidInstallments;
  String? instalmentAmount;
  String? nextDueDate;
  String? frequency;
  String? interestRate;
  String? totalAmountOverdue;
  String? rePaymentMode;
  String? chargesOverdue;
  String? mobileNumber;
  String? sourceSystem;
  int? uCIC;
  String? loanStatus;
  String? installmentOverdue;
  String? loanType;

  BasicDetailsResponse(
      {this.financedAmount,
      this.loanId,
      this.loanNumber,
      this.vehicleRegistrationNumber,
      this.totalOutstandingAmount,
      this.startDate,
      this.endDate,
      this.loanTenure,
      this.status,
      this.numberOfPaidInstallments,
      this.instalmentAmount,
      this.nextDueDate,
      this.frequency,
      this.interestRate,
      this.totalAmountOverdue,
      this.rePaymentMode,
      this.chargesOverdue,
      this.mobileNumber,
      this.sourceSystem,
      this.uCIC,
      this.loanStatus,
      this.installmentOverdue,
      this.loanType});

  BasicDetailsResponse.fromJson(Map<String, dynamic> json) {
    financedAmount = json['loanAmount'] ?? "";
    loanId = json['loanId'] ?? "";
    loanNumber = json['loanNumber'] ?? "";
    vehicleRegistrationNumber = json['vehicleRegistrationNumber'] ?? "";
    totalOutstandingAmount = json['totalOutstandingAmount'] ?? "";
    startDate = json['startDate'] ?? "";
    endDate = json['endDate'] ?? "";
    loanTenure = json['loanTenure'] ?? "";
    status = json['status'] ?? "";
    numberOfPaidInstallments = json['numberOfPaidInstallments'] ?? "";
    instalmentAmount = json['instalmentAmount'] ?? "";
    nextDueDate = json['nextDueDate'] ?? "";
    frequency = json['frequency'] ?? "";
    interestRate = json['interestRate'] ?? "";
    totalAmountOverdue = json['totalAmountOverdue'] ?? "";
    rePaymentMode = json['repaymentMode'] ?? "";
    chargesOverdue = json['chargesOverdue'] ?? "";
    mobileNumber = json['mobileNumber'] ?? "";
    sourceSystem = json['sourceSystem'] ?? "";
    uCIC = json['UCIC'];
    loanStatus = json['loanStatus'] ?? "";
    installmentOverdue = json['installmentOverdue'] ?? "";
    loanType = json["loanType"] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['financedAmount'] = financedAmount;
    data['loanId'] = loanId;
    data['loanNumber'] = loanNumber;
    data['vehicleRegistrationNumber'] = vehicleRegistrationNumber;
    data['totalOutstandingAmount'] = totalOutstandingAmount;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['loanTenure'] = loanTenure;
    data['status'] = status;
    data['numberOfPaidInstallments'] = numberOfPaidInstallments;
    data['instalmentAmount'] = instalmentAmount;
    data['nextDueDate'] = nextDueDate;
    data['frequency'] = frequency;
    data['interestRate'] = interestRate;
    data['totalAmountOverdue'] = totalAmountOverdue;
    data['rePaymentMode'] = rePaymentMode;
    data['chargesOverdue'] = chargesOverdue;
    data['mobileNumber'] = mobileNumber;
    data['sourceSystem'] = sourceSystem;
    data['UCIC'] = uCIC;
    data['loanStatus'] = loanStatus;
    data['installmentOverdue'] = installmentOverdue;
    data['loanType'] = loanType;
    return data;
  }
}

class BasicMandateDetail {
  final String? effectiveFrom;

  BasicMandateDetail({
    this.effectiveFrom,
  });

  factory BasicMandateDetail.fromJson(Map<String, dynamic> json) =>
      BasicMandateDetail(
        effectiveFrom: json["effectiveFrom"],
      );

  Map<String, dynamic> toJson() => {
        "effectiveFrom": effectiveFrom,
      };
}

class InsuranceDetails {
  String? uniqueRequesterId;
  String? policyNo;
  String? policyType;
  String? policyStartDate;
  String? policyExpiryDate;
  String? policyIssueDate;
  String? insuredAmount;
  String? totalPremium;
  String? invoiceNumber;

  InsuranceDetails(
      {this.uniqueRequesterId,
      this.invoiceNumber,
      this.policyNo,
      this.policyType,
      this.policyStartDate,
      this.policyExpiryDate,
      this.policyIssueDate,
      this.insuredAmount,
      this.totalPremium});

  InsuranceDetails.fromJson(Map<String, dynamic> json) {
    uniqueRequesterId = json['UniqueRequesterId'];
    invoiceNumber = json['invoiceNumber'] ?? '-';
    policyNo = json['POLICY_NO'];
    policyType = json['POLICY_TYPE'];
    policyStartDate = json['POLICY_START_DATE'];
    policyExpiryDate = json['POLICY_EXPIRY_DATE'];
    policyIssueDate = json['POLICY_ISSUE_DATE'];
    insuredAmount = json['INSURED_AMOUNT'];
    totalPremium = json['TOTAL_PREMIUM'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UniqueRequesterId'] = uniqueRequesterId;
    data['invoiceNumber'] = invoiceNumber;
    data['POLICY_NO'] = policyNo;
    data['POLICY_TYPE'] = policyType;
    data['POLICY_START_DATE'] = policyStartDate;
    data['POLICY_EXPIRY_DATE'] = policyExpiryDate;
    data['POLICY_ISSUE_DATE'] = policyIssueDate;
    data['INSURED_AMOUNT'] = insuredAmount;
    data['TOTAL_PREMIUM'] = totalPremium;
    return data;
  }

  bool isEmpty() {
    return policyNo == null ||
        policyNo!.isEmpty && policyType == null ||
        policyType!.isEmpty && policyStartDate == null ||
        policyStartDate!.isEmpty && policyExpiryDate == null ||
        policyExpiryDate!.isEmpty && policyIssueDate == null ||
        policyIssueDate!.isEmpty && insuredAmount == null ||
        insuredAmount!.isEmpty && totalPremium == null ||
        totalPremium!.isEmpty;
  }
}

class PaymentHistory {
  final String? paymentInvoiceDownloadlink;
  final List<PaymentDatum>? paymentData;

  PaymentHistory({
    this.paymentInvoiceDownloadlink,
    this.paymentData,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) => PaymentHistory(
        paymentInvoiceDownloadlink: json["paymentInvoiceDownloadlink"],
        paymentData: json["paymentData"] == null
            ? []
            : List<PaymentDatum>.from(
                json["paymentData"]!.map((x) => PaymentDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "paymentInvoiceDownloadlink": paymentInvoiceDownloadlink,
        "paymentData": paymentData == null
            ? []
            : List<dynamic>.from(paymentData!.map((x) => x.toJson())),
      };
}

class PaymentDatum {
  final String? paymentHistoryTitle;
  final String? paymentDate;
  final String? paymentAmount;

  PaymentDatum({
    this.paymentHistoryTitle,
    this.paymentDate,
    this.paymentAmount,
  });

  factory PaymentDatum.fromJson(Map<String, dynamic> json) => PaymentDatum(
        paymentHistoryTitle: json["paymentHistoryTitle"],
        paymentDate: json["paymentDate"],
        paymentAmount: json["paymentAmount"],
      );

  Map<String, dynamic> toJson() => {
        "paymentHistoryTitle": paymentHistoryTitle,
        "paymentDate": paymentDate,
        "paymentAmount": paymentAmount,
      };
}

class RemindersDetails {
  final String? loanId;
  final String? loanNumber;
  final String? sourceSystem;
  final String? nextDueDate;
  final String? status;
  final List<Reminder>? reminder;

  RemindersDetails({
    this.loanId,
    this.loanNumber,
    this.sourceSystem,
    this.nextDueDate,
    this.status,
    this.reminder,
  });

  factory RemindersDetails.fromJson(Map<String, dynamic> json) =>
      RemindersDetails(
        loanId: json["loanId"],
        loanNumber: json["loanNumber"],
        sourceSystem: json["sourceSystem"],
        nextDueDate: json["next_due_date"],
        status: json["status"],
        reminder: json["reminder"] == null
            ? []
            : List<Reminder>.from(
                json["reminder"]!.map((x) => Reminder.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "loanId": loanId,
        "loanNumber": loanNumber,
        "sourceSystem": sourceSystem,
        "next_due_date": nextDueDate,
        "status": status,
        "reminder": reminder == null
            ? []
            : List<dynamic>.from(reminder!.map((x) => x.toJson())),
      };
}

class Reminder {
  final String? reminderId;
  final String? reminderDurationType;
  final DateTime? date;
  final String? time;

  Reminder({
    this.reminderId,
    this.reminderDurationType,
    this.date,
    this.time,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
        reminderId: json["reminder_id"],
        reminderDurationType: json["reminder_duration_type"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "reminder_id": reminderId,
        "reminder_duration_type": reminderDurationType,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "time": time,
      };
}
