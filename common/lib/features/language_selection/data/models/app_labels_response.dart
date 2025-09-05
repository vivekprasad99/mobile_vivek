import 'package:common/features/language_selection/data/models/base_cms_response.dart';

class AppLabelsResponse extends BaseCMSResponse {
  final Map<String, String>? labels;

  AppLabelsResponse({required this.labels});

  factory AppLabelsResponse.fromJson(Map<String, dynamic> json) {
    return AppLabelsResponse(
      labels:
          json['data'] == null ? {} : Map<String, String>.from(json['data']),
    );
  }
}
