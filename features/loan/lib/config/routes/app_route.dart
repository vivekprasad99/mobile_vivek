import 'package:core/services/di/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan/config/routes/route.dart';
import 'package:loan/features/foreclosure/data/models/create_foreclosure_sr_response.dart';

import 'package:loan/features/foreclosure/data/models/get_loan_details_response.dart';
import 'package:loan/features/foreclosure/presentation/cubit/foreclosure_cubit.dart';
import 'package:loan/features/foreclosure/presentation/foreclosure_wireframe/screens/freezing_period_bottom_sheet.dart';
import 'package:loan/features/foreclosure/presentation/foreclosure_wireframe/screens/loans_list_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:loan/features/loan_cancellation/data/models/create_sr_response.dart';
import 'package:loan/features/loan_cancellation/data/models/fetch_sr_response.dart';
import 'package:loan/features/loan_cancellation/data/models/get_lc_list_response.dart';
import 'package:loan/features/loan_cancellation/presentation/cubit/loan_cancellation_cubit.dart';
import 'package:loan/features/loan_cancellation/presentation/loan_cancellation_wireframe/screens/lc_detail_screen.dart';
import 'package:loan/features/loan_cancellation/presentation/loan_cancellation_wireframe/screens/lc_failure_screen.dart';
import 'package:loan/features/loan_cancellation/presentation/loan_cancellation_wireframe/screens/lc_loans_list_screen.dart';
import 'package:loan/features/loan_cancellation/presentation/loan_cancellation_wireframe/screens/lc_offers_screen.dart';
import 'package:loan/features/loan_cancellation/presentation/loan_cancellation_wireframe/screens/lc_payment_overview_screen.dart';
import 'package:loan/features/loan_cancellation/presentation/loan_cancellation_wireframe/screens/service_request_screen.dart';
import '../../features/foreclosure/presentation/foreclosure_wireframe/screens/forceclosure_charges_bottom_sheet.dart';
import '../../features/foreclosure/presentation/foreclosure_wireframe/screens/foreclosure_detail_screen.dart';

final List<GoRoute> loanRoutes = [
  GoRoute(
    path: Routes.loansList.path,
    name: Routes.loansList.name,
    builder: (context, state) => BlocProvider(
      create: (context) => di<ForeclosureCubit>(),
      child: ForeclosureLoansList(isFromServiceTab: state.extra as bool),
    ),
  ),
  GoRoute(
      path: Routes.foreclosureDetail.path,
      name: Routes.foreclosureDetail.name,
      builder: (context, state) {
        return BlocProvider(
          create: (context) => di<ForeclosureCubit>(),
          child:
              ForeclosureDetailScreen(loanDetails: state.extra as LoanDetails),
        );
      }),
  GoRoute(
    path: Routes.foreclosureChargesBottomSheet.path,
    name: Routes.foreclosureChargesBottomSheet.name,
    builder: (context, state) {
      return BlocProvider(
        create: (context) => di<ForeclosureCubit>(),
        child: ForceClosureChargesBottomSheet(
            loanDetails: state.extra as LoanDetails),
      );
    },
  ),
  GoRoute(
    path: Routes.freezingPeriodBottomSheet.path,
    name: Routes.freezingPeriodBottomSheet.name,
    builder: (_, __) => BlocProvider(
      create: (context) => di<ForeclosureCubit>(),
      child: const FreezingPeriodBottomSheet(),
    ),
  ),

  ///Loan Cancellation routes
  GoRoute(
    path: Routes.loanCancelList.path,
    name: Routes.loanCancelList.name,
    builder: (context, state) => BlocProvider(
      create: (context) => di<LoanCancellationCubit>(),
      child: const LoanCancellationListScreen(),
    ),
  ),

  GoRoute(
    path: Routes.loanCancelDetailScreen.path,
    name: Routes.loanCancelDetailScreen.name,
    builder: (context, state) => BlocProvider(
      create: (context) => di<LoanCancellationCubit>(),
      child: LoanCancellationDetailScreen(
        loanDetails: state.extra as LoanCancelItem,
      ),
    ),
  ),

  GoRoute(
    path: Routes.loanCancelFailureScreen.path,
    name: Routes.loanCancelFailureScreen.name,
    builder: (context, state) => BlocProvider(
      create: (context) => di<LoanCancellationCubit>(),
      child: LoanCancellationFailureScreen(
        isNotFlp: state.pathParameters['isNotFlp'] == "true",
        isNotPl: state.pathParameters['isNotPl'] == "true",
        srDetails: state.extra as OpenStatusSrForLc?,
      ),
    ),
  ),

  GoRoute(
    path: Routes.loanCancelServiceTicketScreen.path,
    name: Routes.loanCancelServiceTicketScreen.name,
    builder: (context, state) => BlocProvider(
      create: (context) => di<LoanCancellationCubit>(),
      child: ServiceRequestScreen(
        createSrData: state.extra as CreateSrData,
      ),
    ),
  ),

  GoRoute(
    path: Routes.loanCancelPaymentOverviewScreen.path,
    name: Routes.loanCancelPaymentOverviewScreen.name,
    builder: (context, state) => BlocProvider(
      create: (context) => di<LoanCancellationCubit>(),
      child: LoanCancellationPaymentOverviewScreen(
        loanDetails: state.extra as LoanCancelItem,
      ),
    ),
  ),

  GoRoute(
    path: Routes.loanCancelOffersScreen.path,
    name: Routes.loanCancelOffersScreen.name,
    builder: (context, state) => BlocProvider(
      create: (context) => di<LoanCancellationCubit>(),
      child: LoanCancellationOfferScreen(
        loanDetails: state.extra as LoanCancelItem,
      ),
    ),
  ),
];
