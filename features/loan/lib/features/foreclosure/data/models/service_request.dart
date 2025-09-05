import 'package:core/utils/utils.dart';
class ServiceRequest {
  String? superAppId = getSuperAppId();
  String? customerName = getUserName();
  final String? description;
  final String? customerId;
  final String? lob;
  final int? caseType;
  final String? channel;
  final String? productCategory;
  final String? sourceSystem;
  final String? productName;
  final String? contractId;
  final String? category;
  final String? subCategory;
  final String? srType;
  final String? inAppNotification;
  final String? requestType;
  final String? mobileNumber;
  final String? alternateNumber;
  final String? relatedToSRNo;
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
  String? ocrRequired = "N";

  ServiceRequest({
    this.superAppId,
    required this.customerId,
    required this.contractId,
    required this.caseType,
    required this.channel,
    required this.lob,
    required this.productName,
    required this.description,
    required this.productCategory,
    required this.sourceSystem,
    this.category,
    this.subCategory,
    this.srType,
    this.requestType,
    this.mobileNumber,
    this.alternateNumber,
    this.inAppNotification,
    this.customerName,
    this.relatedToSRNo,
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
    this.ocrRequired
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> json) =>
      ServiceRequest(
          superAppId: json["superAppId"],
          customerId: json["customerId"],
          contractId: json["contractId"],
          caseType: json["caseType"],
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
          ocrRequired: json["ocrFlag"]
      );

  Map<String, dynamic> toJson() => {
    "superAppId": superAppId ?? "",
    "customerId": customerId ?? "",
    "contractId": contractId ?? "",
    "caseType": caseType,
    "category": category ?? "",
    "subCategory": subCategory ?? "",
    "srType": srType ?? "" ,
    "requestType": requestType ?? "",
    "mobileNumber": mobileNumber ?? "",
    "channel": channel ?? "",
    "inAppNotification": inAppNotification ?? "0",
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
    "ocrFlag": ocrRequired ?? ""
  };
}
