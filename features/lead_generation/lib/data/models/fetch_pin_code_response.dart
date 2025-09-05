class FetchPinCodeResponse {
  String? state;
  String? city;

  FetchPinCodeResponse({this.state, this.city});

  FetchPinCodeResponse.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['state'] = state;
    data['city'] = city;
    return data;
  }
}
