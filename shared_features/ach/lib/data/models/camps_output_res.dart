class CampsOutputRes {
  String? code;
  String? message;
  String? responseCode;
  CampsOutput? campsOutput;

  CampsOutputRes({this.code, this.message, this.responseCode, this.campsOutput});

  CampsOutputRes.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    responseCode = json['responseCode'];
    campsOutput = json['data'] != null ? CampsOutput.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = code;
    data['message'] = message;
    data['responseCode'] = responseCode;
    if (campsOutput != null) {
      data['data'] = campsOutput!.toJson();
    }
    return data;
  }
}

class CampsOutput {
  String? status;
  String? errCode;
  String? msg;
  String? mandateRefNo;
  String? trxnNo;
  String? enachAmount;
  String? statusDesc;
  String? acceptanceRefNo;
  String? umrn;
  String? responseDate;
  Req? req;

  CampsOutput(
      {this.status,
        this.errCode,
        this.msg,
        this.mandateRefNo,
        this.trxnNo,
        this.enachAmount,
        this.statusDesc,
        this.acceptanceRefNo,
        this.umrn,
        this.responseDate,
        this.req});

  CampsOutput.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errCode = json['errCode'];
    msg = json['msg'];
    mandateRefNo = json['mandate_ref_no'];
    trxnNo = json['trxn_no'];
    enachAmount = json['enach_amount'];
    statusDesc = json['status_desc'];
    acceptanceRefNo = json['acceptance_ref_no'];
    umrn = json['umn'];
    responseDate = json['responseDate'];
    req = json['req'] != null ? Req.fromJson(json['req']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['errCode'] = errCode;
    data['msg'] = msg;
    data['mandate_ref_no'] = mandateRefNo;
    data['trxn_no'] = trxnNo;
    data['enach_amount'] = enachAmount;
    data['status_desc'] = statusDesc;
    data['acceptance_ref_no'] = acceptanceRefNo;
    data['umn'] = umrn;
    data['responseDate'] = responseDate;
    if (req != null) {
      data['req'] = req!.toJson();
    }
    return data;
  }
}

class Req {
  String? sourceSystem;
  String? trxnno;
  String? enachAmount;
  String? frequencydeduction;
  String? mandatestartdate;
  String? mandateenddate;
  String? payervpa;
  String? enachPayment;
  String? productName;
  String? debittype;
  String? bankcode;
  String? payername;
  String? accountnumber;
  String? pan;
  String? ifsc;
  String? merchantid;
  String? subbillerid;
  String? accountholdername;
  String? untilcancelled;
  String? authenticationmode;
  String? accounttype;
  String? mobileno;
  String? emailid;
  String? responseurl;
  String? redirecturl;
  String? mandatecategory;

  Req(
      {this.sourceSystem,
        this.trxnno,
        this.enachAmount,
        this.frequencydeduction,
        this.mandatestartdate,
        this.mandateenddate,
        this.payervpa,
        this.enachPayment,
        this.productName,
        this.debittype,
        this.bankcode,
        this.payername,
        this.accountnumber,
        this.pan,
        this.ifsc,
        this.merchantid,
        this.subbillerid,
        this.accountholdername,
        this.untilcancelled,
        this.authenticationmode,
        this.accounttype,
        this.mobileno,
        this.emailid,
        this.responseurl,
        this.redirecturl,
        this.mandatecategory});

  Req.fromJson(Map<String, dynamic> json) {
    sourceSystem = json['sourceSystem'];
    trxnno = json['trxnno'];
    enachAmount = json['enach_amount'];
    frequencydeduction = json['frequencydeduction'];
    mandatestartdate = json['mandatestartdate'];
    mandateenddate = json['mandateenddate'];
    payervpa = json['payervpa'];
    enachPayment = json['enach_payment'];
    productName = json['product_name'];
    debittype = json['debittype'];
    bankcode = json['bankcode'];
    payername = json['payername'];
    accountnumber = json['accountnumber'];
    pan = json['pan'];
    ifsc = json['ifsc'];
    merchantid = json['merchantid'];
    subbillerid = json['subbillerid'];
    accountholdername = json['accountholdername'];
    untilcancelled = json['untilcancelled'];
    authenticationmode = json['authenticationmode'];
    accounttype = json['accounttype'];
    mobileno = json['mobileno'];
    emailid = json['emailid'];
    responseurl = json['responseurl'];
    redirecturl = json['redirecturl'];
    mandatecategory = json['mandatecategory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sourceSystem'] = sourceSystem;
    data['trxnno'] = trxnno;
    data['enach_amount'] = enachAmount;
    data['frequencydeduction'] = frequencydeduction;
    data['mandatestartdate'] = mandatestartdate;
    data['mandateenddate'] = mandateenddate;
    data['payervpa'] = payervpa;
    data['enach_payment'] = enachPayment;
    data['product_name'] = productName;
    data['debittype'] = debittype;
    data['bankcode'] = bankcode;
    data['payername'] = payername;
    data['accountnumber'] = accountnumber;
    data['pan'] = pan;
    data['ifsc'] = ifsc;
    data['merchantid'] = merchantid;
    data['subbillerid'] = subbillerid;
    data['accountholdername'] = accountholdername;
    data['untilcancelled'] = untilcancelled;
    data['authenticationmode'] = authenticationmode;
    data['accounttype'] = accounttype;
    data['mobileno'] = mobileno;
    data['emailid'] = emailid;
    data['responseurl'] = responseurl;
    data['redirecturl'] = redirecturl;
    data['mandatecategory'] = mandatecategory;
    return data;
  }
}