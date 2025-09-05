class ApplicationStatusRequest {
  String? mobileNumber;

  ApplicationStatusRequest({this.mobileNumber});

  ApplicationStatusRequest.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['MobileNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MobileNumber'] = mobileNumber;
    return data;
  }
}
