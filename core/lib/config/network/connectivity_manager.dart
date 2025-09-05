import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:vpn_connection_detector/vpn_connection_detector.dart';

class ConnectivityManager {
  late Connectivity connectivity;
  StreamSubscription? connectivitySubscription;

  check({required Function onChanged}) {
    connectivity = Connectivity();
    connectivitySubscription =
        connectivity.onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        onChanged.call(true);
      } else {
        onChanged.call(false);
      }
    });
  }

  cancel() {
    connectivitySubscription?.cancel();
  }

  Future<bool> isVpnConnected() async {
    bool vpnConnected = await VpnConnectionDetector.isVpnActive();

    bool isDeviceVPNConnected = false;
    if (vpnConnected) {
      isDeviceVPNConnected = true;
    }
    return isDeviceVPNConnected;
  }
}
