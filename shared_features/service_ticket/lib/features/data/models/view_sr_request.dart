class ViewSRRequest {
  String? mobileNumber;
  String? srStatus;
  ViewSRRequest({this.mobileNumber, this.srStatus});

  ViewSRRequest.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['mobileNumber'];
    srStatus = json['srStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobileNumber'] = mobileNumber;
    data['srStatus'] = srStatus;
    return data;
  }
}
