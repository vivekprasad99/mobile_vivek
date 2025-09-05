import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';

class SOAWebView extends StatefulWidget {
  const SOAWebView({super.key, required this.url});

  final String url;

  @override
  State<SOAWebView> createState() => SOAWebViewState();
}

class SOAWebViewState extends State<SOAWebView> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      isInspectable: kDebugMode,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true);

  String url = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: const Text('SOA Generated....'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: InAppWebView(
        key: webViewKey,
        initialUrlRequest: URLRequest(url: WebUri(widget.url)),
        initialSettings: settings,
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onLoadStart: (controller, url) {
          this.url = url.toString();
        },
        onPermissionRequest: (controller, request) async {
          return PermissionResponse(
              resources: request.resources,
              action: PermissionResponseAction.GRANT);
        },
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          var uri = navigationAction.request.url!;
          if (![
            "http",
            "https",
            "file",
            "chrome",
            "data",
            "javascript",
            "about"
          ].contains(uri.scheme)) {
            if (await canLaunchUrl(uri)) {
              await launchUrl(
                uri,
              );
              return NavigationActionPolicy.CANCEL;
            }
          } else {
            if (uri.toString() ==
                "https://commonwebapp.mahindrafs.com/SOA_MOBILE_UAT/Success.html") {
              context.pop(true);
            } else {
              context.pop(false);
            }
          }
          return NavigationActionPolicy.ALLOW;
        },
        onLoadStop: (controller, url) async {
          this.url = url.toString();
        },
        onReceivedError: (controller, request, error) {},
        onProgressChanged: (controller, progress) {
          if (progress == 100) {}
        },
        onUpdateVisitedHistory: (controller, url, androidIsReload) {
          this.url = url.toString();
        },
        onConsoleMessage: (controller, consoleMessage) {
          if (kDebugMode) {
            log(consoleMessage.message);
          }
        },
      ),
    );
  }
}
