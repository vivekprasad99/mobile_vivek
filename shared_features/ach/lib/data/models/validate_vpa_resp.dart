class ValidateVpaResp {
  String? code;
  String? message;
  VpaData? data;
  String? responseCode;

  ValidateVpaResp({this.code, this.message, this.data, this.responseCode});

  ValidateVpaResp.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    responseCode = json['responseCode'];
    data = json['data'] != null ? VpaData.fromJson(json['data']) : null;
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

class VpaData {
  String? status;
  String? statusDesc;
  String? vpa;
  String? payerName;
  String? ifsc;
  String? accountType;
  String? isVpaValid;
  String? isAutopayEligible;
  String? errCode;

  VpaData(
      {this.status,
        this.statusDesc,
        this.vpa,
        this.payerName,
        this.ifsc,
        this.accountType,
        this.isVpaValid,
        this.isAutopayEligible,
        this.errCode});

  VpaData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusDesc = json['statusDesc'];
    vpa = json['vpa'];
    payerName = json['payer_name'];
    ifsc = json['ifsc'];
    accountType = json['account_type'];
    isVpaValid = json['is_vpa_valid'];
    isAutopayEligible = json['is_autopay_eligible'];
    errCode = json['errCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['statusDesc'] = statusDesc;
    data['vpa'] = vpa;
    data['payer_name'] = payerName;
    data['ifsc'] = ifsc;
    data['account_type'] = accountType;
    data['is_vpa_valid'] = isVpaValid;
    data['is_autopay_eligible'] = isAutopayEligible;
    data['errCode'] = errCode;
    return data;
  }
}
