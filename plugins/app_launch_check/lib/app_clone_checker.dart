import 'dart:async';

import 'package:flutter/services.dart';

class AppCloneChecker {
  static const MethodChannel _channel = MethodChannel('app_launch_check');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<dynamic> appOriginality(String applicationID,
      {bool isWorkProfileAllowed = true}) async {
    return await _channel.invokeMethod('checkDeviceCloned', {
      "applicationID": applicationID,
      "isWorkProfileAllowed": isWorkProfileAllowed
    });
  }
}
