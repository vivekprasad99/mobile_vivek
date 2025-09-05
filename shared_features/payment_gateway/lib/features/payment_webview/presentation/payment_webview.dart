import 'dart:collection';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:payment_gateway/features/data/models/webview_data_model.dart';

class PaymentWebview extends StatefulWidget {
  final WebViewDataModel? webViewDataModel;

  const PaymentWebview({super.key, @required this.webViewDataModel});

  @override
  State<PaymentWebview> createState() => _PaymentWebviewState();
}

class _PaymentWebviewState extends State<PaymentWebview> {
  InAppWebViewController? inAppWebViewController;
  double progress = 0;
  String? userAgent;

  @override
  void initState() {
    super.initState();
    getAgent();
  }

  Future<void> getAgent() async
  {
    userAgent=  await getUserAgent();   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri(widget.webViewDataModel?.url ?? ""),
            ),
            initialSettings: InAppWebViewSettings(
              supportZoom: false,
              verticalScrollBarEnabled: false,
              useShouldOverrideUrlLoading: true,
              mediaPlaybackRequiresUserGesture: false,
              javaScriptEnabled: true,
              javaScriptCanOpenWindowsAutomatically: true,
              userAgent: userAgent ?? "",
              useHybridComposition: true,
              allowsInlineMediaPlayback: true,
              disallowOverScroll: true,
            ),
            initialUserScripts: UnmodifiableListView([
              UserScript(
                source: """
              window.addEventListener('DOMContentLoaded', function(event) {
                document.getElementsByTagName('header')[0].style.display='none';
          
              document.getElementsByTagName('footer')[0].style.display='none';
              document.getElementsByTagName('a')[0];
          
              });
              """,
                injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
              ),
            ]),
            shouldOverrideUrlLoading:
                (controller, shouldOverrideUrlLoadingRequest) async {
              await widget.webViewDataModel?.onOverrideUrlLoading!(
                  controller, shouldOverrideUrlLoadingRequest);
              return NavigationActionPolicy.ALLOW;
            },
            onUpdateVisitedHistory: (controller, weburl, isReload) {
              widget.webViewDataModel?.onUpdateVisitedHistory!(
                  controller, weburl, isReload);
            },
            onProgressChanged:
                (InAppWebViewController controller, int progress) {
              setState(() {
                this.progress = progress / 100;
              });
            },
          ),
          Align(alignment: Alignment.center, child: _buildProgressBar()),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    if (progress != 1.0) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Center(
            child: CircularProgressIndicator(
          color: Theme.of(context).indicatorColor,
          strokeWidth: 2,
        )),
      );
    }
    return const SizedBox();
  }
}
