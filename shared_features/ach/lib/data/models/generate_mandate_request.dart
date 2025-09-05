class GenerateMandateRequest {

  String? cif;
  String? accountHolderName;
  String? accountType;
  String? authenticationMode;
  String? bankCode;
  String? emailId;
  String? mandateCategory;
  String? mobileNo;
  String? accountNumber;
  String? enachAmount;
  String? ifsc;
  String? mandateStartDate;
  String? mandateEndDate;
  String? pan;
  String? frequencyDeduction;
  String? payerName;
  String? payerVpa;
  String? productName;
  String? sourceSystem;
  String? loanNumber;
  bool? updateRequest;
  String? mandateId;
  String? trxnNo;
  String? batchNumber;
  String? updateReason;
  String? revokeable;
  String? authorize;
  String? authorizerevoke;
  String? aggregator;
  String? superAppId;
  String? source;


  GenerateMandateRequest(
      { this.cif,
        this.accountHolderName,
        this.accountType,
        this.authenticationMode,
        this.bankCode,
        this.emailId,
        this.mandateCategory,
        this.mobileNo,
        this.accountNumber,
        this.enachAmount,
        this.ifsc,
        this.mandateStartDate,
        this.mandateEndDate,
        this.pan,
        this.frequencyDeduction,
        this.payerName,
        this.payerVpa,
        this.productName,
        this.sourceSystem,
        this.loanNumber,
        this.updateRequest,
        this.mandateId,
        this.trxnNo,
        this.batchNumber,
        this.updateReason,
        this.revokeable,
        this.authorize,
        this.authorizerevoke,
        this.aggregator,
        this.superAppId,
        this.source
      });
  //
  GenerateMandateRequest.fromJson(Map<String, dynamic> json) {
    cif = json['cif'];
    accountHolderName = json['accountholdername'];
    accountType = json['accounttype'];
    authenticationMode = json['cif'];
    cif = json['authenticationmode'];
    bankCode = json['bankcode'];
    emailId = json['emailid'];
    mandateCategory = json['mandatecategory'];
    mobileNo = json['mobileno'];
    accountNumber = json['accountnumber'];
    enachAmount = json['enach_amount'];
    mandateStartDate = json['mandatestartdate'];
    mandateEndDate = json['mandateenddate'];
    pan = json['pan'];
    frequencyDeduction = json['frequencydeduction'];
    payerName = json['payername'];
    payerVpa = json['payervpa'];
    productName = json['product_name'];
    sourceSystem = json['sourceSystem'];
    loanNumber = json['loanNumber'];
    updateRequest = json['updateRequest'];
    mandateId = json['mandateId'];
    trxnNo = json['trxnno'];
    batchNumber = json['batchNumber'];
    updateReason = json['updateReason'];
    revokeable = json['revokeable'];
    authorize = json['authorize'];
    authorizerevoke = json['authorizerevoke'];
    aggregator = json['aggregator'];
    superAppId = json['superAppId'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cif'] = cif;
    data['accountholdername'] = accountHolderName;
    data['accounttype'] = accountType;
    data['authenticationmode'] = authenticationMode;
    data['bankcode'] = bankCode;
    data['emailid'] = emailId;
    data['mandatecategory'] = mandateCategory;
    data['mobileno'] = mobileNo;
    data['accountnumber'] = accountNumber;
    data['enach_amount'] = enachAmount;
    data['ifsc'] = ifsc;
    data['mandatestartdate'] = mandateStartDate;
    data['mandateenddate'] = mandateEndDate;
    data['pan'] = pan;
    data['frequencydeduction'] = frequencyDeduction;
    data['payername'] = payerName;
    data['payervpa'] = payerVpa;
    data['product_name'] = productName;
    data['sourceSystem'] = sourceSystem;
    data['loanNumber'] = loanNumber;
    data['updateRequest'] = updateRequest;
    data['mandateId'] = mandateId;
    data['trxnno'] = trxnNo;
    data['updateReason'] = updateReason;
    data['revokeable'] = revokeable;
    data['authorize'] = authorize;
    data['batchNumber'] = batchNumber;
    data['authorizerevoke'] = authorizerevoke;
    data['aggregator'] = aggregator;
    data['superAppId'] = superAppId;
    data['source'] = source;
    return data;
  }
}