
import 'package:webview_flutter/webview_flutter.dart';

class WeviewModel {
  final bool? showAppBar;
  final String? appBarTitle;
  final String? baseUrl;
  final String? responseUrl;
  final String? redirectUrl;

  // final Function(InAppWebViewController, NavigationAction)?
  // onOverrideUrlLoading;
  // final Function(InAppWebViewController, WebUri?, bool?)?
  // onUpdateVisitedHistory;
  final Function(NavigationRequest)? onNavigationRequest;

  WeviewModel({
    required this.showAppBar,
    required this.appBarTitle,
    required this.baseUrl,
    required this.responseUrl,
    required this.redirectUrl,
    // this.onOverrideUrlLoading, this.onUpdateVisitedHistory,
    this.onNavigationRequest
  });
}
