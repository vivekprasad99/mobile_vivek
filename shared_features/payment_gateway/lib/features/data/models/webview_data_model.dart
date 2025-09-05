import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewDataModel {
  final String? url;
  final Function(InAppWebViewController, NavigationAction)?
  onOverrideUrlLoading;
  final Function(InAppWebViewController,WebUri?,bool?)? onUpdateVisitedHistory;

  WebViewDataModel({this.url, this.onOverrideUrlLoading,this.onUpdateVisitedHistory});
}