import 'package:app_launch_check/app_clone_checker.dart';
import 'package:core/utils/device_clone_result.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../flavor/app_config.dart';

class DeviceManager {
  static final DeviceManager _deviceManager = DeviceManager._internal();
  final String isValidApp = "Valid App";

  factory DeviceManager() {
    return _deviceManager;
  }

  DeviceManager._internal();

  Future<String?> getDeviceId() async {
    return await FlutterUdid.udid;
  }

  Future<bool> isAppJailBrokenOrRooted() async {
    bool jailbroken = await FlutterJailbreakDetection.jailbroken;
    bool rooted = await FlutterJailbreakDetection.developerMode;
    bool isDeviceRootedJailbreak = false;
    if (jailbroken || rooted) {
      isDeviceRootedJailbreak = true;
    }
    return isDeviceRootedJailbreak;
  }

  Future<dynamic> isAppCloned() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String packageName = packageInfo.packageName;
      dynamic pluginResponse = await AppCloneChecker.appOriginality(packageName,
          isWorkProfileAllowed: true);
      var resultData = ResultData.fromJson(pluginResponse);
      pluginResponse = resultData.message;
      return pluginResponse != isValidApp;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> enableSecureMode() async {
    return await FlutterWindowManager.addFlags(
        FlutterWindowManager.FLAG_SECURE);
  }

  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return 'V-${packageInfo.version} (${packageInfo.buildNumber})';
  }

  Future<String> getDisplayAppVersion() async {
    return ('${AppConfig.shared.appName} ${await DeviceManager().getAppVersion()}');
  }
}
