class DobGenderMatchResponse {
  String? code;
  String? message;
  String? responseCode;
  int? dobScore;
  int? genderScore;

  DobGenderMatchResponse(
      {this.code,
      this.message,
      this.responseCode,
      this.dobScore,
      this.genderScore});

  DobGenderMatchResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    responseCode = json['responseCode'];
    dobScore = json['dobScore'];
    genderScore = json['genderScore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['responseCode'] = responseCode;
    data['dobScore'] = dobScore;
    data['genderScore'] = genderScore;
    return data;
  }
}
