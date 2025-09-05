class RegisterStatusRequest {
  String? mobileNumber;
  String? source;

  RegisterStatusRequest({this.mobileNumber, this.source});

  RegisterStatusRequest.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['mobileNumber'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobileNumber'] = mobileNumber;
    data['source'] = source;
    return data;
  }
}