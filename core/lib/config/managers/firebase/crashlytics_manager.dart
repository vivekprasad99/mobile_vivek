import 'package:core/config/managers/device_manager.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class CrashlyticsManager {
  CrashlyticsManager._();

  static Future<void> init() async {
    final version = await di<DeviceManager>().getDisplayAppVersion();
    FirebaseCrashlytics.instance.setCustomKey('env', version.split(' ').first);
    FirebaseCrashlytics.instance.setCustomKey('version', version);
  }

  static void recordError(dynamic error, StackTrace stack) async {
    if (kReleaseMode) {
      FirebaseCrashlytics.instance.recordError(
        error,
        stack,
        fatal: true,
      );
    }
  }

  /// This will throw a test exception with custom message.
  ///
  /// if you are testing this on `debug` mode,
  /// please change the condition in [recordError] function!!
  static void testException({
    message = 'This is test exception to check crashlytics implementation!',
  }) {
    throw Exception(message);
  }

  static Future<void> testPlatformException() async {
    const channel = MethodChannel('crashy-custom-channel');
    await channel.invokeMethod('blah');
  }
}
