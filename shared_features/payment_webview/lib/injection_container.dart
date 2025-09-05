import 'package:core/services/di/injection_container.dart';
import 'package:payment_webview/presentation/cubit/payment_webview_cubit.dart';

Future<void> initPaymentWebViewDI() async {
  di.registerFactory(() => PaymentWebViewCubit());
}
