class FetchSrResponse {
  final String? code;
  final String? message;
  final List<OpenStatusSrForLc>? openStatusSrForLc;

  FetchSrResponse({
    this.code,
    this.message,
    this.openStatusSrForLc,
  });

  factory FetchSrResponse.fromJson(Map<String, dynamic> json) =>
      FetchSrResponse(
        code: json["code"],
        message: json["message"],
        openStatusSrForLc: json["openStatusSRForLC"] == null
            ? []
            : List<OpenStatusSrForLc>.from(json["openStatusSRForLC"]!
                .map((x) => OpenStatusSrForLc.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "openStatusSRForLC": openStatusSrForLc == null
            ? []
            : List<dynamic>.from(openStatusSrForLc!.map((x) => x.toJson())),
      };
}

class OpenStatusSrForLc {
  final String? caseNumber;
  final String? lan;
  final String? caseType;
  final String? subCaseType;
  final String? category;
  final String? status;
  final String? customerId;
  final String? caseCreatedAt;
  final bool? enablePayment;
  final String? type;

  OpenStatusSrForLc({
    this.caseNumber,
    this.lan,
    this.caseType,
    this.subCaseType,
    this.category,
    this.status,
    this.customerId,
    this.caseCreatedAt,
    this.enablePayment,
    this.type,
  });

  factory OpenStatusSrForLc.fromJson(Map<String, dynamic> json) =>
      OpenStatusSrForLc(
        caseNumber: json["caseNumber"],
        lan: json["lan"],
        caseType: json["caseType"],
        subCaseType: json["subCaseType"],
        category: json["category"],
        status: json["status"],
        customerId: json["customerId"],
        caseCreatedAt: json["caseCreatedAt"],
        enablePayment: json["enablePayment"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "caseNumber": caseNumber,
        "lan": lan,
        "caseType": caseType,
        "subCaseType": subCaseType,
        "category": category,
        "status": status,
        "customerId": customerId,
        "caseCreatedAt": caseCreatedAt,
        "enablePayment": enablePayment,
        "type": type,
      };
}
