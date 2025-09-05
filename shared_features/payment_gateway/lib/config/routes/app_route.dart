import 'package:common/features/rate_us/presentation/cubit/rate_us_cubit.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:payment_gateway/config/routes/route.dart';
import 'package:payment_gateway/features/domain/models/payment_model.dart';
import 'package:payment_gateway/features/presentation/screens/choose_payment_mode_screen.dart';
import 'package:payment_gateway/features/presentation/screens/payment_receipt_screen.dart';
import 'package:payment_gateway/features/presentation/screens/payment_success_screen.dart';
import 'package:payment_gateway/features/presentation/utils/services/payment_screen_feed_model.dart';

import '../../features/data/models/webview_data_model.dart';
import '../../features/payment_webview/presentation/payment_webview.dart';
import '../../features/presentation/cubit/payment_cubit.dart';

final List<GoRoute> paymentRoutes = [
  GoRoute(
      path: Routes.choosePaymentMode.path,
      name: Routes.choosePaymentMode.name,
      builder: (context, state) => BlocProvider<PaymentGatewayCubit>(
            create: (context) => di<PaymentGatewayCubit>(),
            child: ChoosePaymentModeScreen(
                paymentModel: state.extra as PaymentModel),
          )),
  GoRoute(
      path: Routes.paymentSuccess.path,
      name: Routes.paymentSuccess.name,
      builder: (context, state) => BlocProvider<PaymentGatewayCubit>(
            create: (context) => di<PaymentGatewayCubit>(),
            child: BlocProvider<RateUsCubit>(
              create: (context) => di<RateUsCubit>(),
              child: PaymentSuccessScreen(
                paymentData: state.extra as PaymentStatusDataModel,
              ),
            ),
          )),
  GoRoute(
    path: Routes.paymentWebview.path,
    name: Routes.paymentWebview.name,
    builder: (context, state) {
      return PaymentWebview(
        webViewDataModel: state.extra as WebViewDataModel,
      );
    },
  ),
  GoRoute(
      path: Routes.paymentReceipt.path,
      name: Routes.paymentReceipt.name,
      builder: (context, state) => BlocProvider<PaymentGatewayCubit>(
            create: (context) => di<PaymentGatewayCubit>(),
            child: PaymentReceiptScreen(
              paymentData: state.extra as PaymentStatusDataModel,
            ),
          )),
];
