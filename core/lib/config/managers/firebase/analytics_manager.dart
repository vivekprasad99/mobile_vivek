import 'package:core/config/managers/device_manager.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import './firebase_options.dart';

class AnalyticsManager {
  AnalyticsManager._();

  /// Call this method before the run `runapp` to initialize the firebase.
  static Future<void> init({
    setAnalyticsCollectionEnabled = true,
  }) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(
      setAnalyticsCollectionEnabled,
    );
    final version = await di<DeviceManager>().getDisplayAppVersion();
    await FirebaseAnalytics.instance.setUserProperty(
      name: 'env',
      value: version.split(' ').first,
    );
    await FirebaseAnalytics.instance.setUserProperty(
      name: 'version',
      value: version,
    );
  }

  /// Used in `app_route.dart`
  static FirebaseAnalyticsObserver getNavigatorObserver() {
    return FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);
  }

  /// Adds parameters that will be set on every event logged from the SDK,
  /// including automatic ones.
  static Future<void> Function(Map<String, Object?>? defaultParameters)
      setDefaultEventParameters =
      FirebaseAnalytics.instance.setDefaultEventParameters;

  /// Logs a custom Flutter Analytics event with the given [name] and event [parameters].
  static Future<void> logEvent({
    required String name,
    Map<String, Object?>? parameters,
  }) async {
    FirebaseAnalytics.instance.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  /// Logs the standard screen_view event.
  static Future<void> Function({
    String? screenClass,
    String? screenName,
    Map<String, Object?>? parameters,
    AnalyticsCallOptions? callOptions,
  }) logScreenView = FirebaseAnalytics.instance.logScreenView;
}
