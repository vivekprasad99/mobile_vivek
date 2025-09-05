import 'package:common/features/startup/presentation/cubit/app_launch_cubit.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:core/config/managers/device_manager.dart';
import 'package:core/config/network/connectivity_manager.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_launch_cubit_test.mocks.dart';

@GenerateMocks([DeviceManager, ConnectivityManager])
void main() {
  late AppLaunchCubit cubit;
  MockConnectivityManager mockConnectivityManager = MockConnectivityManager();
  MockDeviceManager mockDeviceManager = MockDeviceManager();

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await PrefUtils.init();

    cubit = AppLaunchCubit(
      connectivityManager: mockConnectivityManager,
      deviceManager: mockDeviceManager,
    );
    when(mockConnectivityManager.cancel()).thenReturn(cubit);
  });

  group('test app launch checks', () {
    blocTest(
      'should emit rootJailBreakState if device is jail break/ rooted',
      build: () {
        when(mockDeviceManager.isAppJailBrokenOrRooted())
            .thenAnswer((_) async => true);
        return cubit;
      },
      act: (AppLaunchCubit cubit) {
        cubit.checkAppHealth();
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        AppLaunchState.rootJailBreakState,
      ],
    );

    blocTest(
      'should emit vpn active state if device has active vpn connection',
      build: () {
        when(mockDeviceManager.isAppJailBrokenOrRooted())
            .thenAnswer((_) async => false);
        when(mockConnectivityManager.isVpnConnected())
            .thenAnswer((_) async => true);
        when(mockDeviceManager.getDeviceId()).thenAnswer((_) async => '123');
        return cubit;
      },
      act: (AppLaunchCubit cubit) {
        cubit.checkAppHealth();
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        AppLaunchState.vpnConnectedState,
      ],
    );

    blocTest(
      'should emit appclone state if app is cloned in device',
      build: () {
        when(mockDeviceManager.isAppJailBrokenOrRooted())
            .thenAnswer((_) async => false);
        when(mockConnectivityManager.isVpnConnected())
            .thenAnswer((_) async => false);
        when(mockDeviceManager.isAppCloned()).thenAnswer((_) async => true);
        when(mockDeviceManager.getDeviceId()).thenAnswer((_) async => '123');
        return cubit;
      },
      act: (AppLaunchCubit cubit) {
        cubit.checkAppHealth();
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        AppLaunchState.appClonedState,
      ],
    );

    blocTest(
      'should emit appLaunchSuccessState if app has all check passed',
      build: () {
        when(mockDeviceManager.isAppJailBrokenOrRooted())
            .thenAnswer((_) async => false);
        when(mockConnectivityManager.isVpnConnected())
            .thenAnswer((_) async => false);
        when(mockDeviceManager.isAppCloned()).thenAnswer((_) async => false);
        when(mockDeviceManager.isScreenSharingOn())
            .thenAnswer((_) async => false);
        when(mockDeviceManager.isScreenRecordingOn())
            .thenAnswer((_) async => false);
        when(mockDeviceManager.getDeviceId()).thenAnswer((_) async => '123');
        return cubit;
      },
      act: (AppLaunchCubit cubit) {
        cubit.checkAppHealth();
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        AppLaunchState.appLaunchSuccessState,
      ],
    );
  });
}
