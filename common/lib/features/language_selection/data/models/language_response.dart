import 'package:common/features/language_selection/data/models/base_cms_response.dart';

class SelectLanguageResponse extends BaseCMSResponse {
  Data? data;

  SelectLanguageResponse({this.data});

  SelectLanguageResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Language>? languages;

  Data({this.languages});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['languages'] != null) {
      languages = <Language>[];
      json['languages'].forEach((v) {
        languages!.add(Language.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (languages != null) {
      data['languages'] = languages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Language {
  String? langTitle;
  String? langName;
  String? langCode;
  String? langImg;
  bool isSelected = false;

  Language(
      {this.langName,
      this.langCode,
      this.langTitle,
      this.langImg,
      this.isSelected = false,});

  Language.fromJson(Map<String, dynamic> json) {
    langTitle = json['lang_title'];
    langName = json['lang_name'];
    langCode = json['lang_code'] ?? 'en';
    langImg = json['lang_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lang_title'] = langTitle;
    data['lang_name'] = langName;
    data['lang_code'] = langCode;
    data['lang_img'] = langImg;
    return data;
  }
}
