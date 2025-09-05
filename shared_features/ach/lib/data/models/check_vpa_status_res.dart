class CheckVpaStatusRes{
  String? code;
  String? message;
  String? responseCode;
  VpaStatus? data;

  CheckVpaStatusRes({this.code, this.message, this.responseCode, this.data});

  CheckVpaStatusRes.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    responseCode = json['responseCode'];
    data = json['data'] != null ? VpaStatus.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['responseCode'] = responseCode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class VpaStatus {
  String? merchantid;
  String? subbillerid;
  String? cpMdtRefNo;
  String? umn;
  String? trxnno;
  String? amount;
  String? status;
  String? statusdesc;
  String? pattern;
  String? accountno;
  String? ifsc;
  String? schemes;
  String? payervpa;
  String? payername;
  String? bankname;
  String? action;
  String? bankErrorCode;
  String? bankErrorDesc;
  String? bankResCode;
  String? bankResDesc;

  VpaStatus(
      {this.merchantid,
        this.subbillerid,
        this.cpMdtRefNo,
        this.umn,
        this.trxnno,
        this.amount,
        this.status,
        this.statusdesc,
        this.pattern,
        this.accountno,
        this.ifsc,
        this.schemes,
        this.payervpa,
        this.payername,
        this.bankname,
        this.action,
        this.bankErrorCode,
        this.bankErrorDesc,
        this.bankResCode,
        this.bankResDesc});

  VpaStatus.fromJson(Map<String, dynamic> json) {
    merchantid = json['merchantid'];
    subbillerid = json['subbillerid'];
    cpMdtRefNo = json['cp_mdt_ref_no'];
    umn = json['umn'];
    trxnno = json['trxnno'];
    amount = json['amount'];
    status = json['status'];
    statusdesc = json['statusdesc'];
    pattern = json['pattern'];
    accountno = json['accountno'];
    ifsc = json['ifsc'];
    schemes = json['schemes'];
    payervpa = json['payervpa'];
    payername = json['payername'];
    bankname = json['bankname'];
    action = json['action'];
    bankErrorCode = json['bank_error_code'];
    bankErrorDesc = json['bank_error_desc'];
    bankResCode = json['bank_res_code'];
    bankResDesc = json['bank_res_desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['merchantid'] = merchantid;
    data['subbillerid'] = subbillerid;
    data['cp_mdt_ref_no'] = cpMdtRefNo;
    data['umn'] = umn;
    data['trxnno'] = trxnno;
    data['amount'] = amount;
    data['status'] = status;
    data['statusdesc'] = statusdesc;
    data['pattern'] = pattern;
    data['accountno'] = accountno;
    data['ifsc'] = ifsc;
    data['schemes'] = schemes;
    data['payervpa'] = payervpa;
    data['payername'] = payername;
    data['bankname'] = bankname;
    data['action'] = action;
    data['bank_error_code'] = bankErrorCode;
    data['bank_error_desc'] = bankErrorDesc;
    data['bank_res_code'] = bankResCode;
    data['bank_res_desc'] = bankResDesc;
    return data;
  }
}