import 'dart:async';
import 'package:vpn_connection_detector/vpn_connection_detector.dart';

class VPNCheckManager {
  late VpnConnectionDetector vpnConnectionCheck;
  StreamSubscription? vpnConnectionDetectorSubscription;

  check({required Function onChanged}) async {
    return await VpnConnectionDetector.isVpnActive();
  }

  cancel() {
    vpnConnectionDetectorSubscription?.cancel();
  }
}
