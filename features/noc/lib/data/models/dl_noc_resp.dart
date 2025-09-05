class DlNocResp {
  final String code;
  final String message;
  final String responseCode;
  final DLNocData data;

  DlNocResp({
    required this.code,
    required this.message,
    required this.responseCode,
    required this.data,
  });

  factory DlNocResp.fromJson(Map<String, dynamic> json) => DlNocResp(
        code: json["code"],
        message: json["message"],
        responseCode: json["responseCode"],
        data: DLNocData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "responseCode": responseCode,
        "data": data.toJson(),
      };
}

class DLNocData {
  final String finReference;
  final String docContent;
  final ReturnStatus returnStatus;

  DLNocData({
    required this.finReference,
    required this.docContent,
    required this.returnStatus,
  });

  factory DLNocData.fromJson(Map<String, dynamic> json) => DLNocData(
        finReference: json["finReference"],
        docContent: json["docContent"],
        returnStatus: ReturnStatus.fromJson(json["returnStatus"]),
      );

  Map<String, dynamic> toJson() => {
        "finReference": finReference,
        "docContent": docContent,
        "returnStatus": returnStatus.toJson(),
      };
}

class ReturnStatus {
  final String returnCode;
  final String returnText;

  ReturnStatus({
    required this.returnCode,
    required this.returnText,
  });

  factory ReturnStatus.fromJson(Map<String, dynamic> json) => ReturnStatus(
        returnCode: json["returnCode"],
        returnText: json["returnText"],
      );

  Map<String, dynamic> toJson() => {
        "returnCode": returnCode,
        "returnText": returnText,
      };
}
