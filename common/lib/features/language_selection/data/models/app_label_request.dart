class AppLabelRequest {
  String? langCode;

  AppLabelRequest({this.langCode});

  AppLabelRequest.fromJson(Map<String, dynamic> json) {
    langCode = json['lang_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lang_code'] = langCode;
    return data;
  }
}
