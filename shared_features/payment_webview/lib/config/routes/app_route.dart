import 'package:core/services/di/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:payment_webview/config/routes/route.dart';
import 'package:payment_webview/data/models/payment_model.dart';
import 'package:payment_webview/presentation/cubit/payment_webview_cubit.dart';
import 'package:payment_webview/presentation/screens/payment_webview_screen.dart';

final List<GoRoute> paymentWebViewRoutes = [
  GoRoute(
    path: Routes.paymentWebviewScreen.path,
    name: Routes.paymentWebviewScreen.name,
    builder: (context, state) => BlocProvider(
      create: (context) => di<PaymentWebViewCubit>(),
      child: PaymentWebviewScreen(model: state.extra as WeviewModel),
    ),
  )
];
