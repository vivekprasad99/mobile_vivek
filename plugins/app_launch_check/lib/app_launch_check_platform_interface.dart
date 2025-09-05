import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'app_launch_check_method_channel.dart';

abstract class AppLaunchCheckPlatform extends PlatformInterface {
  AppLaunchCheckPlatform() : super(token: _token);

  static final Object _token = Object();

  static AppLaunchCheckPlatform _instance = MethodChannelAppLaunchCheck();

  static AppLaunchCheckPlatform get instance => _instance;

  static set instance(AppLaunchCheckPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
