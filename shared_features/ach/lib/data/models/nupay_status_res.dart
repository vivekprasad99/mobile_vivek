class NupayStatusRes {
  String? code;
  String? message;
  String? responseCode;
  NupayData? nupayData;

  NupayStatusRes({this.code, this.message, this.responseCode, this.nupayData});

  NupayStatusRes.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    responseCode = json['responseCode'];
    nupayData = json['data'] != null ? NupayData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = code;
    data['message'] = message;
    data['responseCode'] = responseCode;
    if (nupayData != null) {
      data['data'] = nupayData!.toJson();
    }
    return data;
  }
}

class NupayData {
  Response? response;
  String? error;
  String? message;
  String? serviceName;

  NupayData({this.response, this.error, this.message, this.serviceName});

  NupayData.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? Response.fromJson(json['response'])
        : null;
    error = json['error'];
    message = json['message'];
    serviceName = json['serviceName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (response != null) {
      data['response'] = response!.toJson();
    }
    data['error'] = error;
    data['message'] = message;
    data['serviceName'] = serviceName;
    return data;
  }
}

class Response {
  String? statusCode;
  Data? data;

  Response({this.statusCode, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StatusCode'] = statusCode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Customer? customer;

  Data({this.customer});

  Data.fromJson(Map<String, dynamic> json) {
    customer = json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    return data;
  }
}

class Customer {
  String? id;
  int? colltnAmt;
  String? submittedOn;
  String? accptd;
  bool? colltnUntilCncl;
  String? debitType;
  String? name;
  String? mobileNo;
  String? telNo;
  String? email;
  String? seqTp;
  String? frqcy;
  String? frstColltnDt;
  String? fnlColltnDt;
  String? expiresAt;
  List<BankAccounts>? bankAccounts;
  String? accptRefNo;
  String? reasonCode;
  String? reasonDesc;
  String? rejectBy;
  String? npciRefNo;
  String? umrn;

  Customer(
      {this.id,
        this.colltnAmt,
        this.submittedOn,
        this.accptd,
        this.colltnUntilCncl,
        this.debitType,
        this.name,
        this.mobileNo,
        this.telNo,
        this.email,
        this.seqTp,
        this.frqcy,
        this.frstColltnDt,
        this.fnlColltnDt,
        this.expiresAt,
        this.bankAccounts,
        this.accptRefNo,
        this.reasonCode,
        this.reasonDesc,
        this.rejectBy,
        this.npciRefNo,
        this.umrn});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    colltnAmt = json['colltn_amt'];
    submittedOn = json['submitted_on'];
    accptd = json['accptd'];
    colltnUntilCncl = json['colltn_until_cncl'];
    debitType = json['debit_type'];
    name = json['name'];
    mobileNo = json['mobile_no'];
    telNo = json['tel_no'];
    email = json['email'];
    seqTp = json['seq_tp'];
    frqcy = json['frqcy'];
    frstColltnDt = json['frst_colltn_dt'];
    fnlColltnDt = json['fnl_colltn_dt'];
    expiresAt = json['expires_at'];
    if (json['bank_accounts'] != null) {
      bankAccounts = <BankAccounts>[];
      json['bank_accounts'].forEach((v) {
        bankAccounts!.add(BankAccounts.fromJson(v));
      });
    }
    accptRefNo = json['accpt_ref_no'];
    reasonCode = json['reason_code'];
    reasonDesc = json['reason_desc'];
    rejectBy = json['reject_by'];
    npciRefNo = json['npci_ref_no'];
    umrn = json['umrn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['colltn_amt'] = colltnAmt;
    data['submitted_on'] = submittedOn;
    data['accptd'] = accptd;
    data['colltn_until_cncl'] = colltnUntilCncl;
    data['debit_type'] = debitType;
    data['name'] = name;
    data['mobile_no'] = mobileNo;
    data['tel_no'] = telNo;
    data['email'] = email;
    data['seq_tp'] = seqTp;
    data['frqcy'] = frqcy;
    data['frst_colltn_dt'] = frstColltnDt;
    data['fnl_colltn_dt'] = fnlColltnDt;
    data['expires_at'] = expiresAt;
    if (bankAccounts != null) {
      data['bank_accounts'] =
          bankAccounts!.map((v) => v.toJson()).toList();
    }
    data['accpt_ref_no'] = accptRefNo;
    data['reason_code'] = reasonCode;
    data['reason_desc'] = reasonDesc;
    data['reject_by'] = rejectBy;
    data['npci_ref_no'] = npciRefNo;
    data['umrn'] = umrn;
    return data;
  }
}

class BankAccounts {
  String? accountHolderName;
  String? bankAccountNo;
  String? authType;
  String? accountType;
  String? pancard;
  String? ifscCode;
  String? companyIfscCode;

  BankAccounts(
      {this.accountHolderName,
        this.bankAccountNo,
        this.authType,
        this.accountType,
        this.pancard,
        this.ifscCode,
        this.companyIfscCode});

  BankAccounts.fromJson(Map<String, dynamic> json) {
    accountHolderName = json['account_holder_name'];
    bankAccountNo = json['bank_account_no'];
    authType = json['auth_type'];
    accountType = json['account_type'];
    pancard = json['pancard'];
    ifscCode = json['ifsc_code'];
    companyIfscCode = json['company_ifsc_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['account_holder_name'] = accountHolderName;
    data['bank_account_no'] = bankAccountNo;
    data['auth_type'] = authType;
    data['account_type'] = accountType;
    data['pancard'] = pancard;
    data['ifsc_code'] = ifscCode;
    data['company_ifsc_code'] = companyIfscCode;
    return data;
  }
}