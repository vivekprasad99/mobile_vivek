class DocumentsResponse {
  final String? code;
  final String? message;
  final String? responseCode;
  final Kfs? kfs;
  final FinOneSoa? finOneSoa;
  final PennantSoa? pennantSoa;
  final AutoFinSoa? autoFinSoa;
  final RepaymentScheduleResponse? repaymentSchedule;

  DocumentsResponse({
    this.code,
    this.message,
    this.responseCode,
    this.kfs,
    this.finOneSoa,
    this.pennantSoa,
    this.autoFinSoa,
    this.repaymentSchedule,
  });

  factory DocumentsResponse.fromJson(Map<String, dynamic> json) =>
      DocumentsResponse(
        code: json["code"],
        message: json["message"],
        responseCode: json["responseCode"],
        kfs: json["kfs"] == null ? null : Kfs.fromJson(json["kfs"]),
        finOneSoa: json["finOneSoa"] == null
            ? null
            : FinOneSoa.fromJson(json["finOneSoa"]),
        pennantSoa: json["pennantSoa"] == null
            ? null
            : PennantSoa.fromJson(json["pennantSoa"]),
        autoFinSoa: json["soa"] == null
            ? null
            : AutoFinSoa.fromJson(json["soa"]),
        repaymentSchedule: json["repaymentSchedule"] == null
            ? null
            : RepaymentScheduleResponse.fromJson(json),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "responseCode": responseCode,
        "kfs": kfs?.toJson(),
        "finOneSoa": finOneSoa?.toJson(),
        "pennantSoa": pennantSoa?.toJson(),
        "soa": autoFinSoa?.toJson(),
        "repaymenttSchedule": repaymentSchedule?.toJson(),
      };
}

class FinOneSoa {
  final String? pdfData;
  final String? fileName;
  final String? contentType;

  FinOneSoa({
    this.pdfData,
    this.fileName,
    this.contentType,
  });

  factory FinOneSoa.fromJson(Map<String, dynamic> json) => FinOneSoa(
        pdfData: json["pdfData"],
        fileName: json["fileName"],
        contentType: json["contentType"],
      );

  Map<String, dynamic> toJson() => {
        "pdfData": pdfData,
        "fileName": fileName,
        "contentType": contentType,
      };
}

class Kfs {
  final NgoGetDocumentBdoResponse? ngoGetDocumentBdoResponse;

  Kfs({
    this.ngoGetDocumentBdoResponse,
  });

  factory Kfs.fromJson(Map<String, dynamic> json) => Kfs(
        ngoGetDocumentBdoResponse: json["NGOGetDocumentBDOResponse"] == null
            ? null
            : NgoGetDocumentBdoResponse.fromJson(
                json["NGOGetDocumentBDOResponse"]),
      );

  Map<String, dynamic> toJson() => {
        "NGOGetDocumentBDOResponse": ngoGetDocumentBdoResponse?.toJson(),
      };
}

class NgoGetDocumentBdoResponse {
  final String? createdByAppName;
  final String? docContent;
  final String? documentName;
  final String? documentSize;
  final String? documentType;
  final String? message;
  final String? statusCode;

  NgoGetDocumentBdoResponse({
    this.createdByAppName,
    this.docContent,
    this.documentName,
    this.documentSize,
    this.documentType,
    this.message,
    this.statusCode,
  });

  factory NgoGetDocumentBdoResponse.fromJson(Map<String, dynamic> json) =>
      NgoGetDocumentBdoResponse(
        createdByAppName: json["createdByAppName"],
        docContent: json["docContent"],
        documentName: json["documentName"],
        documentSize: json["documentSize"],
        documentType: json["documentType"],
        message: json["message"],
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "createdByAppName": createdByAppName,
        "docContent": docContent,
        "documentName": documentName,
        "documentSize": documentSize,
        "documentType": documentType,
        "message": message,
        "statusCode": statusCode,
      };
}

class PennantSoa {
  final String? message;
  final Response? response;
  final String? error;
  final String? serviceName;

  PennantSoa({
    this.message,
    this.response,
    this.error,
    this.serviceName,
  });

  factory PennantSoa.fromJson(Map<String, dynamic> json) => PennantSoa(
        message: json["message"],
        response: json["response"] == null
            ? null
            : Response.fromJson(json["response"]),
        
        error: json["error"],
        serviceName: json["serviceName"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "response": response?.toJson(),
        "error": error,
        "serviceName": serviceName,
      };
}

class AutoFinSoa {
  final String? status;
  final Data? data;
  String? responseEncryptedData;
  String? errorCode;
  List<String>? messages;

  AutoFinSoa({
    this.status,
    this.data,
    this.responseEncryptedData,
    this.errorCode,
    this.messages
  });

  factory AutoFinSoa.fromJson(Map<String, dynamic> json) => AutoFinSoa(
    status: json['status'],
    data: json['data'] != null ? Data.fromJson(json['data']) : null,
    responseEncryptedData: json['responseEncryptedData'],
    errorCode: json['errorCode']
  );
  
  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data,
    "responseEncryptedData": responseEncryptedData,
    'errorCode': errorCode
  };
}

class Data {
  String? contractNo;
  String? fromDate;
  String? afcRate;
  String? generatedFrom;
  String? status;
  String? empcode;
  String? dateOfGen;
  String? browser;
  String? ipAddress;
  String? imageurl;

  Data(
      {this.contractNo,
        this.fromDate,
        this.afcRate,
        this.generatedFrom,
        this.status,
        this.empcode,
        this.dateOfGen,
        this.browser,
        this.ipAddress,
        this.imageurl});

  Data.fromJson(Map<String, dynamic> json) {
    contractNo = json['contractNo'];
    fromDate = json['fromDate'];
    afcRate = json['afcRate'];
    generatedFrom = json['generatedFrom'];
    status = json['status'];
    empcode = json['empcode'];
    dateOfGen = json['dateOfGen'];
    browser = json['browser'];
    ipAddress = json['ipAddress'];
    imageurl = json['imageurl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['contractNo'] = contractNo;
    data['fromDate'] = fromDate;
    data['afcRate'] = afcRate;
    data['generatedFrom'] = generatedFrom;
    data['status'] = status;
    data['empcode'] = empcode;
    data['dateOfGen'] = dateOfGen;
    data['browser'] = browser;
    data['ipAddress'] = ipAddress;
    data['imageurl'] = imageurl;
    return data;
  }
}

class Response {
  final String? finReference;
  final String? docContent;
  final ReturnStatus? returnStatus;

  Response({
    this.finReference,
    this.docContent,
    this.returnStatus,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        finReference: json["finReference"],
        docContent: json["docContent"],
        returnStatus: json["returnStatus"] == null
            ? null
            : ReturnStatus.fromJson(json["returnStatus"]),
      );

  Map<String, dynamic> toJson() => {
        "finReference": finReference,
        "docContent": docContent,
        "returnStatus": returnStatus?.toJson(),
      };
}

class ReturnStatus {
  final String? returnCode;
  final String? returnText;

  ReturnStatus({
    this.returnCode,
    this.returnText,
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

class RepaymentScheduleResponse {
  List<RepaymentSchedule>? repaymentSchedule;

  RepaymentScheduleResponse({
    this.repaymentSchedule,
  });

  factory RepaymentScheduleResponse.fromJson(Map<String, dynamic> json) =>
      RepaymentScheduleResponse(
        repaymentSchedule: json["repaymentSchedule"] == null
            ? []
            : List<RepaymentSchedule>.from(json["repaymentSchedule"]!
                .map((x) => RepaymentSchedule.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "repaymentSchedule": repaymentSchedule == null
            ? []
            : List<dynamic>.from(repaymentSchedule!.map((x) => x.toJson())),
      };
}

class RepaymentSchedule {
  String? installmentNumber;
  String? dueDate;
  String? installmentAmount;
  String? principalComponent;
  String? interestComponent;
  String? outstandingPrincipal;

  RepaymentSchedule({
    this.installmentNumber,
    this.dueDate,
    this.installmentAmount,
    this.principalComponent,
    this.interestComponent,
    this.outstandingPrincipal,
  });

  factory RepaymentSchedule.fromJson(Map<String, dynamic> json) =>
      RepaymentSchedule(
        installmentNumber: json["installmentNumber"],
        dueDate: json["dueDate"],
        installmentAmount: json["installmentAmount"],
        principalComponent: json["principalComponent"],
        interestComponent: json["interestComponent"],
        outstandingPrincipal: json["outstandingPrincipal"],
      );

  Map<String, dynamic> toJson() => {
        "installmentNumber": installmentNumber,
        "dueDate": dueDate,
        "installmentAmount": installmentAmount,
        "principalComponent": principalComponent,
        "interestComponent": interestComponent,
        "outstandingPrincipal": outstandingPrincipal,
      };
}
