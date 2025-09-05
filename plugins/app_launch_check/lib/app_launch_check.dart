import 'app_launch_check_platform_interface.dart';

class AppLaunchCheck {
  Future<String?> getPlatformVersion() {
    return AppLaunchCheckPlatform.instance.getPlatformVersion();
  }
}
