class ApplicationStatusResponse {
  String? code;
  String? message;
  List<Data>? loanApplicationStatusList;
  String? responseCode;

  ApplicationStatusResponse(
      {this.code, this.message, this.loanApplicationStatusList,this.responseCode});

  ApplicationStatusResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    responseCode = json['responseCode'];
    if (json['loanApplicationStatusList'] != null) {
      loanApplicationStatusList = <Data>[];
      json['loanApplicationStatusList'].forEach((v) {
        loanApplicationStatusList!.add(Data.fromJson(v));
      });
    } else {
      json['loanApplicationStatusList'] = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['responseCode'] = responseCode;
    if (loanApplicationStatusList != null) {
      data['loanApplicationStatusList'] =
          loanApplicationStatusList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? applicantName;
  String? applicationDate;
  String? currentDate;
  String? applicationNumber;
  String? applicationStatus;
  String? assetName;
  String? branchName;
  String? businessExecutiveContactNumber;
  String? businessExecutiveName;
  String? subStatus;
  String? stage;
  String? loanType;
  String? lmsType;

  Data(
      {required this.applicantName,
      required this.applicationDate,
      required this.currentDate,
      required this.applicationNumber,
      required this.applicationStatus,
      required this.assetName,
      required this.branchName,
      required this.businessExecutiveContactNumber,
      required this.businessExecutiveName,
      required this.subStatus,
      required this.stage,
      required this.loanType,
      required this.lmsType});

  Data.fromJson(Map<String, dynamic> json) {
    applicantName = json['applicantName'] ?? "Invalid";
    applicationDate = json['applicationDate'] ?? "Invalid";
    currentDate = json['currentDate'] ?? "Invalid";
    applicationNumber = json['applicationNumber'] ?? "Invalid";
    applicationStatus = json['applicationStatus'] ?? "Invalid";
    assetName = json['assetName'] ?? "Invalid";
    branchName = json['branchName'] ?? "Invalid";
    businessExecutiveContactNumber =
        json['businessExecutiveContactNumber'] ?? "Invalid";
    businessExecutiveName = json['businessExecutiveName'] ?? "";
    subStatus = json['subStatus'] ?? "";
    stage = json['stage'] ?? "";
    loanType = json['loanType'] ?? "";
    lmsType = json['lmsType'] ?? "Invalid";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['applicantName'] = applicantName;
    data['applicationDate'] = applicationDate;
    data['currentDate'] = currentDate;
    data['applicationNumber'] = applicationNumber;
    data['applicationStatus'] = applicationStatus;
    data['assetName'] = assetName;
    data['branchName'] = branchName;
    data['businessExecutiveContactNumber'] = businessExecutiveContactNumber;
    data['businessExecutiveName'] = businessExecutiveName;
    data['subStatus'] = subStatus;
    data['stage'] = stage;
    data['loanType'] = loanType;
    data['lmsType'] = lmsType;
    return data;
  }
}
