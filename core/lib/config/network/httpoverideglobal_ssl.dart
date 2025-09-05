import 'dart:io';
import 'package:core/utils/helper/log.dart';

class MyHttpOverrides extends HttpOverrides {
  @override

  HttpClient createHttpClient(SecurityContext? context) {

    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        log.d("port : $port");
        return true;
      }; // add your localhost detection logic here if you want
  }
}