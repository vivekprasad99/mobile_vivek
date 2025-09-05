class CreateMandateStatusRes{
  String? mandateRefNo;
  String? trxnNo;
  String? enachAmount;
  String? statusDesc;
  String? status;
  String? acceptanceRefNo;
  String? successPage;
  String? umn;
  String? superAppId;
  String? source;

  CreateMandateStatusRes(
      {this.mandateRefNo,
        this.trxnNo,
        this.enachAmount,
        this.statusDesc,
        this.status,
        this.acceptanceRefNo,
        this.successPage,
        this.umn,
        this.source,
        this.superAppId});

  CreateMandateStatusRes.fromJson(Map<String, dynamic> json) {
    mandateRefNo = json['mandate_ref_no'];
    trxnNo = json['trxn_no'];
    enachAmount = json['enach_amount'];
    statusDesc = json['status_desc'];
    status = json['status'];
    acceptanceRefNo = json['acceptance_ref_no'];
    successPage = json['success_page'];
    umn = json['umn'];
    source = json['source'];
    superAppId = json['superAppId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mandate_ref_no'] = mandateRefNo;
    data['trxn_no'] = trxnNo;
    data['enach_amount'] = enachAmount;
    data['status_desc'] = statusDesc;
    data['status'] = status;
    data['acceptance_ref_no'] = acceptanceRefNo;
    data['success_page'] = successPage;
    data['umn'] = umn;
    data['source'] = source;
    data['superAppId'] = superAppId;
    return data;
  }
}