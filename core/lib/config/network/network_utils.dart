import 'package:core/utils/utils.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../flavor/app_config.dart';

final preLoginTokenUserName = dotenv.env["preLoginTokenUserName"] ?? '';
final preLoginTokenPassword = dotenv.env["preLoginTokenPassword"] ?? '';
final postLoginTokenUserName = dotenv.env["postLoginTokenUserName"] ?? '';
final postLoginTokenPassword = dotenv.env["postLoginTokenPassword"] ?? '';
final rsaPublicKey = dotenv.env["rsaPublicKey"] ?? '';

String getMsApiUrl(String endPoint) {
  return AppConfig.shared.msSuffix + endPoint;
}

String getCMSApiUrl(String endPoint,{String? category}) {
  if (endPoint.contains('?')) {
    return '${AppConfig.shared.msSuffix}$endPoint&language=${"en"}';
  }
  else if (category != null && category.isNotEmpty) {
    return '${AppConfig.shared.msSuffix}$endPoint?language=${getSelectedLanguage()}&category=$category';
  } else {
    return '${AppConfig.shared.msSuffix}$endPoint?language=${getSelectedLanguage()}';
  }
}

String getPostTokenUrl(String endPoint) {
  return AppConfig.shared.postLoginTokenSuffix + endPoint;
}

String getCMSApiUrlWithOutLang(String endPoint) {
  return AppConfig.shared.msSuffix+endPoint;
}

String getPreLoginTokenUrl(String endPoint) {
  return "/oauth/cc/v1/$endPoint";
}

String getPostLoginTokenUrl(String endPoint) {
  return "/oauth/oneApp/v1/$endPoint";
}

bool isCMSApi(String endpoint) {
  return endpoint.contains('language');
}

Map<String, String> getCMSImageHeader() {
  return {'Authorization': 'Bearer ${getAccessToken()}'};
}
