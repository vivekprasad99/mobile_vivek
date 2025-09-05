class FetchApplicantNameRes {
  String? code;
  String? message;
  String? responseCode;
  Data? data;

  FetchApplicantNameRes({this.code, this.message, this.responseCode, this.data});

  FetchApplicantNameRes.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    responseCode = json['responseCode'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  String? applicantName;
  String? coApplicantName;

  Data({this.applicantName, this.coApplicantName});

  Data.fromJson(Map<String, dynamic> json) {
    applicantName = json['applicantName'];
    coApplicantName = json['coApplicantName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['applicantName'] = applicantName;
    data['coApplicantName'] = coApplicantName;
    return data;
  }
}