import 'package:billpayments/config/routes/route.dart';
import 'package:billpayments/features/presentation/cubit/bill_payments_cubit.dart';
import 'package:billpayments/features/presentation/screens/bill_payments_page/pay_screen.dart';
import 'package:billpayments/features/presentation/screens/bill_payments_page/payment_detail_screen.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final List<GoRoute> billPaymentsRoutes = [
  GoRoute(
      path: Routes.billPayments.path,
      name: Routes.billPayments.name,
      builder: (_, __) => BlocProvider<BillPaymentsCubit>(
          create: (context) => di<BillPaymentsCubit>(),
          child: const PayScreen())),
      GoRoute(
      path: Routes.paymentDetails.path,
      name: Routes.paymentDetails.name,
      builder: (context, state) => BlocProvider<BillPaymentsCubit>(
            create: (context) => di<BillPaymentsCubit>(),
            child: const PaymentDetailScreen(),
          )),
];