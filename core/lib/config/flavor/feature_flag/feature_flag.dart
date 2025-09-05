import '../app_config.dart';

bool isFeatureEnabled({required String featureName}) {
  return AppConfig.shared.featureFlag[featureName] ?? false;
}
