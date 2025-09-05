import 'package:core/config/string_resource/strings.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:payment_webview/data/models/payment_model.dart';
import 'package:payment_webview/presentation/cubit/payment_webview_cubit.dart';
import 'package:payment_webview/presentation/cubit/payment_webview_state.dart';
import 'package:payment_webview/presentation/screens/payment_error_screen.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebviewScreen extends StatefulWidget {
  final WeviewModel model;

  const PaymentWebviewScreen({super.key, required this.model});

  @override
  State<PaymentWebviewScreen> createState() => _PaymentWebviewScreenState();
}

class _PaymentWebviewScreenState extends State<PaymentWebviewScreen> {
  // late InAppWebViewController webView;
  late WebViewController webViewController;
  bool _showPaymentError = false;

  @override
  void initState() {
    super.initState();
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          // onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) async {
            widget.model.onNavigationRequest!(request);
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.model.baseUrl ?? ""));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _exitApp(context),
        child: SafeArea(
            top: true,
            child: Scaffold(
              appBar: widget.model.showAppBar == true
                  ? customAppbar(
                      context: context,
                      title: widget.model.appBarTitle ?? "",
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  : null,
              body: BlocConsumer<PaymentWebViewCubit, PaymentWebViewState>(
                listener: (context, state) {
                  if (state is PaymentErrorState) {
                    _showPaymentError = state.showError;
                  }
                },
                builder: (context, state) {
                  return Stack(children: [
                    Visibility(
                        visible: true,
                        child: WebViewWidget(controller: webViewController)),
                    Visibility(
                        visible: _showPaymentError,
                        child: const PaymentErrorScreen())
                  ]);
                },
              ),
            )));
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (await webViewController.canGoBack()) {
      webViewController.goBack();
      return Future.value(false);
    } else {
      displayAlertWithAction(context, getString(msgCancelMandateProcess),
          rightBtnLbl: getString(lblYes), rightBtnTap: () {
        context.pop();
      }, leftBtnLbl: getString(lblNo), leftBtnTap: null);
      return Future.value(false);
      // }
    }
  }
}
