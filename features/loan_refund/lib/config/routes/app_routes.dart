import 'package:ach/data/models/get_ach_loans_response.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_refund/config/routes/route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_refund/features/presentation/cubit/loan_refund_cubit.dart';
import 'package:loan_refund/features/presentation/screens/loan_refund_pages/loan_refund_preview.dart';
import 'package:loan_refund/features/presentation/screens/loan_refund_pages/raise_refund.dart';
import 'package:loan_refund/features/presentation/screens/loan_refund_pages/refund_loans_list_screen.dart';
import 'package:service_ticket/features/presentation/cubit/service_request_cubit.dart';
import '../../features/presentation/screens/loan_refund_pages/adjust_only_preview.dart';
import '../../features/presentation/screens/loan_refund_pages/no_refund_raise_query.dart';

final List<GoRoute> loanRefundRoutes = [
  GoRoute(
      path: Routes.loanRefund.path,
      name: Routes.loanRefund.name,
      builder: (_, __) =>
          BlocProvider<LoanRefundCubit>(
              create: (context) => di<LoanRefundCubit>(),
              child: const RefundLoansList())),
  GoRoute(
      path: Routes.raiseRefund.path,
      name: Routes.raiseRefund.name,
      builder: (context, state) {
        Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        return BlocProvider<LoanRefundCubit>(
            create: (context) => di<LoanRefundCubit>(),
            child: RaiseRefund(
                loanList: args['loanList'],
                loanData: args['loanData'] as LoanData,
                refundAmount: args['refundAmount']));
      }),
  GoRoute(
    path: Routes.navigateToAchloansListfromSR.path,
    name: Routes.navigateToAchloansListfromSR.name,
    builder: (context, state) {
      return BlocProvider(
        create: (context) => di<LoanRefundCubit>(),
        child: const RefundLoansList(),
      );
    },
  ),
  GoRoute(
      path: Routes.navigateToRefundPreview.path,
      name: Routes.navigateToRefundPreview.name,
      builder: (context, state) {
        Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        return BlocProvider(
            create: (context) => di<ServiceRequestCubit>(),
            child: LoanRefundPreview(
                loanData: args["loanData"] ?? [],
                revisedRefund: args["revisedRefund"] ?? 0.0,
                srDescription: args["srDesc"],
                refundStatus: args["refundStatus"],
                isDues: args["isDues"]
            ));
      }),
  GoRoute(
      path: Routes.adjustPreviewScreen.path,
      name: Routes.adjustPreviewScreen.name,
      builder: (context, state) {
        Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => di<ServiceRequestCubit>()),
            BlocProvider(create: (context) => di<LoanRefundCubit>()),
          ],
          child: AdjustPreviewScreen(
            loanData: args["loanData"],
            isSRRequired: args["is_sr_required"],
            srDescription: args["sr_desc"],
            isDues: args["isDues"],
            loanList: args['loanList'] ?? [],
            refundStatus: args['refundStatus'],
          ),
        );
      }),
  GoRoute(
      path: Routes.navigateToLoanRefundRaiseQuery.path,
      name: Routes.navigateToLoanRefundRaiseQuery.name,
      builder: (_, __) => const NoRefundRaiseQuery()),
];
