class GetMandateResponse {
  String? code;
  String? message;
  String? responseCode;
  List<MandateData>? data;

  GetMandateResponse({this.code, this.message, this.responseCode, this.data});

  GetMandateResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    responseCode = json['responseCode'];
    if (json['data'] != null) {
      data = <MandateData>[];
      json['data'].forEach((v) {
        data!.add(MandateData.fromJson(v));
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

class MandateData {
  String? loanAccountNumber;
  String? batchNo;
  String? startDate;
  String? expiryDate;
  String? accHolderName;
  String? bankName;
  String? bankBranch;
  String? bankAccountNo;
  String? umrnNo;
  String? mandateStatus;
  String? installmentAmount;
  String? frequency;
  String? bankCode;
  String? mandateId;
  String? cif;

  MandateData({this.loanAccountNumber,
    this.batchNo,
    this.startDate,
    this.expiryDate,
    this.accHolderName,
    this.bankName,
    this.bankBranch,
    this.bankAccountNo,
    this.umrnNo,
    this.mandateStatus,
    this.installmentAmount,
    this.frequency,
    this.bankCode,
    this.mandateId,
    this.cif});

  MandateData.fromJson(Map<String, dynamic> json) {
    loanAccountNumber = json['loanNumber'];
    batchNo = json['batchNo'];
    startDate = json['startDate'];
    expiryDate = json['expiryDate'];
    accHolderName = json['accHolderName'];
    bankName = json['bankName'];
    bankBranch = json['bankBranch'];
    bankAccountNo = json['bankAccountNo'];
    umrnNo = json['umrnNo'];
    mandateStatus = json['mandate_status'];
    installmentAmount = json['installmant_amount'];
    frequency = json['frequency'];
    bankCode = json['bankCode'];
    mandateId = json['mandateId'];
    cif = json['cif'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['loanNumber'] = loanAccountNumber;
    data['batchNo'] = batchNo;
    data['startDate'] = startDate;
    data['expiryDate'] = expiryDate;
    data['accHolderName'] = accHolderName;
    data['bankName'] = bankName;
    data['bankBranch'] = bankBranch;
    data['bankAccountNo'] = bankAccountNo;
    data['umrnNo'] = umrnNo;
    data['mandate_status'] = mandateStatus;
    data['installmant_amount'] = installmentAmount;
    data['frequency'] = frequency;
    data['bankCode'] = bankCode;
    data['mandateId'] = mandateId;
    data['cif'] = cif;
    return data;
  }
}