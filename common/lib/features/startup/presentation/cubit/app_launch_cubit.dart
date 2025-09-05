import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:core/config/flavor/feature_flag/feature_flag.dart';
import 'package:core/config/flavor/feature_flag/feature_flag_keys.dart';
import 'package:core/config/managers/device_manager.dart';
import 'package:core/config/managers/app_inactivity_manager.dart';
import 'package:core/config/network/connectivity_manager.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

enum AppLaunchState {
  internetInitialState,
  internetOnState,
  internetOffState,
  rootJailBreakState,
  vpnConnectedState,
  appClonedState,
  appLaunchSuccessState,
  appLaunchLoadingOnState,
  appLaunchLoadingOffState,
  inactive,
}


class AppLaunchCubit extends Cubit<AppLaunchState> {
  final ConnectivityManager connectivityManager;
  final DeviceManager deviceManager;

  AppLaunchCubit({
    required this.connectivityManager,
    required this.deviceManager,
  }) : super(AppLaunchState.internetInitialState);

  final _appInactivityManager = AppInactivityManager(
    duration: const Duration(minutes: 5),
  );

  Completer _userLoginCompleter = Completer();

  void startInactivityTracker() async {
    _appInactivityManager.reset();
    _userLoginCompleter = Completer();
    await _userLoginCompleter.future;
    _appInactivityManager.initialize(
      onTimeout: () {
        log.i('onTimeout called in cubit');
        emit(AppLaunchState.appLaunchSuccessState);
        emit(AppLaunchState.inactive);
      },
    );
  }

  void appActive() => _appInactivityManager.onUserInteraction();

  void userLoggedIn(){
    _userLoginCompleter.complete();
  }

  @override
  Future<void> close() {
    connectivityManager.cancel();
    return super.close();
  }

  void checkAppHealth() async {
    _checkRootJailBreak();
  }

  void checkInternetContectivity() {
    _checkInternetConnectivity();
  }

  void _checkRootJailBreak() async {
    bool isJailBreak = await deviceManager.isAppJailBrokenOrRooted();
    if (isJailBreak && isFeatureEnabled(featureName: featureEnableJailBreak)) {
      emit(AppLaunchState.rootJailBreakState);
    } else {
      _fetchDeviceId();
      emit(AppLaunchState.appLaunchSuccessState);
      //_checkVPNConnectivity();
    }
  }

  _checkInternetConnectivity() async{
    ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      emit(AppLaunchState.internetOnState);
      setNetworkConnectivity(true);
    } else {
      emit(AppLaunchState.internetOffState);
      setNetworkConnectivity(false);
    }
    connectivityManager.check(onChanged: (isConnected) {
      if (!isConnected) {
        emit(AppLaunchState.internetOffState);
        setNetworkConnectivity(false);
      } else {
        emit(AppLaunchState.internetOnState);
        setNetworkConnectivity(true);
      }
    },);
  }

  _checkVPNConnectivity() async {
    bool isVpnConnected = await connectivityManager.isVpnConnected();
    if (isVpnConnected && !isFeatureEnabled(featureName: featureBrowserstack)) {
      emit(AppLaunchState.vpnConnectedState);
    } else {
      if(Platform.isAndroid) {
        _checkAppCloning();
      } else {
        emit(AppLaunchState.appLaunchSuccessState);
      }
    }
  }

  _checkAppCloning() async {
    try {
      bool isAppCloned = await deviceManager.isAppCloned();
      isAppCloned
          ? emit(AppLaunchState.appClonedState)
          : emit(AppLaunchState.appLaunchSuccessState);
    } on PlatformException {
      emit(AppLaunchState.appClonedState);
    }
  }

  void _fetchDeviceId() async {
    String? deviceId = await deviceManager.getDeviceId();
    PrefUtils.saveString(PrefUtils.keyDeviceId, deviceId!);
    log.d('Device ID: $deviceId');
  }

  permissionForSimCardDetails() async {
    if (!await MobileNumber.hasPhonePermission) {
      await MobileNumber.requestPhonePermission;
      return;
    }

    var status = await Permission.phone.status;
    if (!status.isGranted) {
      status = await Permission.phone.request();
    }
  }
}
