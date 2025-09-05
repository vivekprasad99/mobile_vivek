class CreateSrRequest {
  final String? customerId;
  final String? category;
  final String? subCategory;
  final String? srType;
  final String? inAppNotification;
  final String? lob;
  final String? productName;
  final String? requestType;
  final String? channel;
  final String? mobileNumber;
  final String? alternateNumber;
  final String? customerName;
  final String? relatedToSRNo;
  final String? description;
  final String? remarks;
  final String? bankAccountNo;
  final String? bankBranch;
  final String? bankName;
  final String? customerName2;
  final String? documentLink;
  final String? ifscCode;
  final String? ocrBankAccountNo;
  final String? ocrBankBranch;
  final String? ocrBankName;
  final String? ocrCustomerName;
  final String? ocrIfscCode;
  final String? pennyDropAccountStatus;
  final String? pennyDropBeneficiaryName;
  final String? pennyDropNameMatchScore;
  final String? refundStatus;
  final String? productCategory;
  final String? sourceSystem;
  final String? contractId;
  final int? caseType;

  CreateSrRequest({
    this.customerId,
    this.category,
    this.subCategory,
    this.srType,
    this.requestType,
    this.mobileNumber,
    this.alternateNumber,
    this.channel,
    this.inAppNotification,
    this.lob,
    this.productName,
    this.customerName,
    this.relatedToSRNo,
    this.description,
    this.remarks,
    this.bankAccountNo,
    this.bankBranch,
    this.bankName,
    this.customerName2,
    this.documentLink,
    this.ifscCode,
    this.ocrBankAccountNo,
    this.ocrBankBranch,
    this.ocrBankName,
    this.ocrCustomerName,
    this.ocrIfscCode,
    this.pennyDropAccountStatus,
    this.pennyDropBeneficiaryName,
    this.pennyDropNameMatchScore,
    this.refundStatus,
    this.productCategory,
    this.sourceSystem,
    this.contractId,
    this.caseType,
  });

  factory CreateSrRequest.fromJson(Map<String, dynamic> json) =>
      CreateSrRequest(
        customerId: json["customerId"],
        category: json["category"],
        subCategory: json["subCategory"],
        srType: json["srType"],
        requestType: json["requestType"],
        mobileNumber: json["mobileNumber"],
        alternateNumber: json["alternateNumber"],
        channel: json["channel"],
        inAppNotification: json["inAppNotification"],
        lob: json["lob"],
        productName: json["productName"],
        customerName: json["customerName"],
        relatedToSRNo: json["relatedToSRNo"],
        description: json["description"],
        remarks: json["remarks"],
        bankAccountNo: json["bankAccountNo"],
        bankBranch: json["bankBranch"],
        bankName: json["bankName"],
        customerName2: json["customerName2"],
        documentLink: json["documentLink"],
        ifscCode: json["ifscCode"],
        ocrBankAccountNo: json["ocrBankAccountNo"],
        ocrBankBranch: json["ocrBankBranch"],
        ocrBankName: json["ocrBankName"],
        ocrCustomerName: json["ocrCustomerName"],
        ocrIfscCode: json["ocrIfscCode"],
        pennyDropAccountStatus: json["pennyDropAccountStatus"],
        pennyDropBeneficiaryName: json["pennyDropBeneficiaryName"],
        pennyDropNameMatchScore: json["pennyDropNameMatchScore"],
        refundStatus: json["refundStatus"],
        productCategory: json["productCategory"],
        sourceSystem: json["sourceSystem"],
        contractId: json['contractId'],
        caseType: json['caseType'],
      );

  Map<String, dynamic> toJson() => {
        "customerId": customerId ?? "",
        "category": category ?? "",
        "subCategory": subCategory ?? "",
        "srType": srType ?? "",
        "requestType": requestType ?? "",
        "mobileNumber": mobileNumber ?? "",
        "channel": channel ?? "",
        "inAppNotification": inAppNotification ?? "",
        "lob": lob ?? "",
        "productName": productName ?? "",
        "customerName": customerName ?? "",
        "relatedToSRNo": relatedToSRNo ?? "",
        "description": description ?? "",
        "remarks": remarks ?? "",
        "bankAccountNo": bankAccountNo ?? "",
        "bankBranch": bankBranch ?? "",
        "bankName": bankName ?? "",
        "customerName2": customerName2 ?? "",
        "documentLink": documentLink ?? "",
        "ifscCode": ifscCode ?? "",
        "ocrBankAccountNo": ocrBankAccountNo ?? "",
        "ocrBankBranch": ocrBankBranch ?? "",
        "ocrBankName": ocrBankName ?? "",
        "ocrCustomerName": ocrCustomerName ?? "",
        "ocrIfscCode": ocrIfscCode ?? "",
        "pennyDropAccountStatus": pennyDropAccountStatus ?? "",
        "pennyDropBeneficiaryName": pennyDropBeneficiaryName ?? "",
        "pennyDropNameMatchScore": pennyDropNameMatchScore ?? "",
        "refundStatus": refundStatus ?? "",
        "productCategory": productCategory ?? "",
        "sourceSystem": sourceSystem ?? "",
        "contractId": contractId ?? "",
        "caseType": caseType ?? ""
      };
}
