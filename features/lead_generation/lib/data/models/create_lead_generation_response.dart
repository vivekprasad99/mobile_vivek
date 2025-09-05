class CreateLeadGenerationResponse {
  String? code;
  String? message;
  String? enquiryId;
  String? responseCode;

  CreateLeadGenerationResponse(
      {this.code, this.message, this.enquiryId, this.responseCode});

  CreateLeadGenerationResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    enquiryId = json['enquiryId'];
    responseCode = json['responseCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['enquiryId'] = enquiryId;
    data['responseCode'] = responseCode;
    return data;
  }
}
