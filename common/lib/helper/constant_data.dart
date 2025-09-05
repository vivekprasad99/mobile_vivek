// singleton
class ConstantData {
  ConstantData._();
  static ConstantData get = ConstantData._();

  String appName = 'MMFSL';
  String platform = 'App';

  static const String dualAppMsg =
      'App is Cloned. Please Delete the Cloned App and try again';

  static const String internetNotConnected = 'Internet connection required to access OneApp Please enable wi-fi or data to continue.';

  static const String rootedMsg = 'This device is rooted. Exit the app.';
  static const String vpnMsg =
      'This device is connected to VPN, please disconnect VPN to continue and try again.';
  static const String appClonedMessage =
      'This device app cloned with your app, please remove the cloned app and try again.';
  static const String appScreenRecordingMsg =
      'Please stop recording the screen and try again.';
}
