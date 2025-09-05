import 'package:flutter_test/flutter_test.dart';
import 'package:app_launch_check/app_launch_check.dart';
import 'package:app_launch_check/app_launch_check_platform_interface.dart';
import 'package:app_launch_check/app_launch_check_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAppLaunchCheckPlatform
    with MockPlatformInterfaceMixin
    implements AppLaunchCheckPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AppLaunchCheckPlatform initialPlatform = AppLaunchCheckPlatform.instance;

  test('$MethodChannelAppLaunchCheck is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAppLaunchCheck>());
  });

  test('getPlatformVersion', () async {
    AppLaunchCheck appLaunchCheckPlugin = AppLaunchCheck();
    MockAppLaunchCheckPlatform fakePlatform = MockAppLaunchCheckPlatform();
    AppLaunchCheckPlatform.instance = fakePlatform;

    expect(await appLaunchCheckPlugin.getPlatformVersion(), '42');
  });
}
