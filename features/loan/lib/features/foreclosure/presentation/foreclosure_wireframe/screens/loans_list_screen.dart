import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loan/features/foreclosure/data/models/get_loans_request.dart';
import 'package:loan/features/foreclosure/presentation/cubit/foreclosure_cubit.dart';
import 'package:core/config/resources/custom_elevated_button.dart';
import 'package:loan/features/foreclosure/presentation/foreclosure_wireframe/widgets/foreclosure_item.dart';
import '../../../data/models/get_loan_details_response.dart';
import 'forceclosure_charges_bottom_sheet.dart';
import 'freezing_period_bottom_sheet.dart';
import 'package:common/config/routes/route.dart' as common;

class ForeclosureLoansList extends StatelessWidget {
  final bool? isFromServiceTab;

  const ForeclosureLoansList({super.key, this.isFromServiceTab = false});

  @override
  Widget build(BuildContext context) {

    GetLoansRequest request = GetLoansRequest(ucic: getUCIC());
    BlocProvider.of<ForeclosureCubit>(context).getLoans(request);
    return Scaffold(
      appBar: customAppbar(
        context: context,
        title: getString(msgLoanForeclosure),
        onPressed: () {
          if (isFromServiceTab == true) {
            context.goNamed(common.Routes.home.name,extra: 4);
          }else{
            context.pop();
          }
        },
      ),
      body: MFGradientBackground(
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(getString(selectLoan),
                    style: Theme.of(context).textTheme.bodyLarge),
                SizedBox(height: 20.v),
                const ForeClosureItem(),
                SizedBox(height: 60.v)
              ],
            ),
            BlocBuilder<ForeclosureCubit, ForeclosureState>(
              builder: (context, state) {
                return CustomElevatedButton(
                  height: 42.v,
                  width: 328.h,
                  text: getString(lblProceed),
                  buttonStyle: ElevatedButton.styleFrom(
                      backgroundColor: enableProceedButton(state)
                          ? Theme.of(context).highlightColor
                          : Theme.of(context).disabledColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.h),
                      )),
                  buttonTextStyle: enableProceedButton(state)
                      ? Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.white)
                      : Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).unselectedWidgetColor),
                  alignment: Alignment.bottomCenter,
                  onPressed: () {
                    proceedButtonPressed(context, state);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  bool enableProceedButton(ForeclosureState state) {
    if (state is GetLoanDetailsSuccessState) {
      if ((state.response.data?.isServiceRequestExist ?? false) == false &&
          (state.response.data?.isLockingPeriod ?? false) == false) {
        return true;
      }
    }
    return false;
  }

  proceedButtonPressed(BuildContext context, ForeclosureState state) {
    if (state is GetLoanDetailsSuccessState) {
      if (state.response.data?.isFreezePeriod == true) {
        showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return const FreezingPeriodBottomSheet();
            });
      } else {

        LoanDetails? loanDetails = state.response.data;
        loanDetails?.lob = state.selectLoanItem.lob ?? "";
        loanDetails?.productName = state.selectLoanItem.productName ?? "";
        loanDetails?.mobileNumber = state.selectLoanItem.mobileNumber ?? "";
        loanDetails?.cif = state.selectLoanItem.cif ?? "";

        showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return ForceClosureChargesBottomSheet(loanDetails: loanDetails);
            });
      }
    }
  }
}
