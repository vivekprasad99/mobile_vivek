class GenerateUpiMandateResponse {
  String? code;
  String? message;
  String? responseCode;
  AggregatorResponse? aggregatorResponse;

  GenerateUpiMandateResponse(
      {this.code, this.message, this.responseCode, this.aggregatorResponse});

  GenerateUpiMandateResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    responseCode = json['responseCode'];
    aggregatorResponse =
        json['data'] != null ? AggregatorResponse.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['responseCode'] = responseCode;
    if (aggregatorResponse != null) {
      data['data'] = aggregatorResponse!.toJson();
    }
    return data;
  }
}

class AggregatorResponse {
  String? mandateRefNo;
  String? status;
  String? errDesc;

  AggregatorResponse({this.mandateRefNo, this.status, this.errDesc});

  AggregatorResponse.fromJson(Map<String, dynamic> json) {
    mandateRefNo = json['cp_mdt_ref_no'];
    status = json['status'];
    errDesc = json['errDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cp_mdt_ref_no'] = mandateRefNo;
    data['status'] = status;
    data['errDesc'] = errDesc;
    return data;
  }
}
