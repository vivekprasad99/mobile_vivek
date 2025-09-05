import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'app_launch_check_platform_interface.dart';

class MethodChannelAppLaunchCheck extends AppLaunchCheckPlatform {

  @visibleForTesting
  final methodChannel = const MethodChannel('app_launch_check');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
