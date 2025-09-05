import 'dart:developer';

import 'package:common/config/routes/app_route.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan/config/routes/route.dart';
import 'package:loan/features/loan_cancellation/data/models/fetch_sr_request.dart';
import 'package:loan/features/loan_cancellation/data/models/fetch_sr_response.dart';
import 'package:loan/features/loan_cancellation/data/models/get_lc_list_response.dart';
import 'package:loan/features/loan_cancellation/presentation/cubit/loan_cancellation_cubit.dart';

class LCSrStatusCheck extends StatelessWidget {
  final LoanCancelItem? loanDetails;
  const LCSrStatusCheck({super.key, required this.loanDetails});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Center(
        child: BlocProvider(
          create: (context) => di<LoanCancellationCubit>()
            ..fetchSR(FetchSrRequest(
              loanAccountNumber: loanDetails?.loanAccountNumber,
              mobileNumber: loanDetails?.mobileNumber,
            )),
          child: BlocListener<LoanCancellationCubit, LoanCancellationState>(
            listener: (context, state) {
              if (state is FetchSrSuccessState) {
                _navigateSR(
                    state.response, loanDetails, state.flpTenureDays, context);
              } else if (state is FetchSrFailureState) {
                Navigator.of(context).pop();
              }
            },
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

void _navigateSR(
  FetchSrResponse srResponse,
  LoanCancelItem? loanDetails,
  int? flpTenureDays,
  BuildContext context,
) {
  try {
    Navigator.of(context).pop();
    if (srResponse.openStatusSrForLc!
        .where((element) =>
            element.subCaseType?.toLowerCase().replaceAll(" ", "") ==
            "loancancellation")
        .toList()
        .isEmpty) {
      if (DateTime.now()
              .difference(loanDetails?.startDate ?? DateTime.now())
              .inDays <=
          ((flpTenureDays ?? 0) - 2)) {
        AppRoute.router
            .pushNamed(Routes.loanCancelOffersScreen.name, extra: loanDetails);
      } else {
        AppRoute.router
            .pushNamed(Routes.loanCancelFailureScreen.name, pathParameters: {
          'isNotPl': "false",
          'isNotFlp': "true",
        });
      }
    } else {
      if (srResponse.openStatusSrForLc!
              .firstWhere(
                (element) =>
                    element.subCaseType?.toLowerCase().replaceAll(" ", "") ==
                    "loancancellation",
              )
              .enablePayment ==
          false) {
        AppRoute.router.pushNamed(
          Routes.loanCancelFailureScreen.name,
          extra: srResponse.openStatusSrForLc!.firstWhere((element) =>
              element.subCaseType?.toLowerCase().replaceAll(" ", "") ==
              "loancancellation"),
          pathParameters: {
            'isNotPl': "true",
            'isNotFlp': "false",
          },
        );
      } else {
        AppRoute.router.pushNamed(Routes.loanCancelPaymentOverviewScreen.name,
            extra: loanDetails);
      }
    }
  } catch (e) {
    log(e.toString());
  }
}
