import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/custom_elevated_button.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loan/config/routes/route.dart';
import 'package:loan/features/loan_cancellation/data/models/get_lc_list_request.dart';
import 'package:loan/features/loan_cancellation/presentation/cubit/loan_cancellation_cubit.dart';
import 'package:loan/features/loan_cancellation/presentation/loan_cancellation_wireframe/widgets/lc_items_list.dart';
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';
class LoanCancellationListScreen extends StatelessWidget {
  const LoanCancellationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GetLoansCancellationRequest request =
        GetLoansCancellationRequest(ucic: getUCIC());
    BlocProvider.of<LoanCancellationCubit>(context).getLoans(request);
    return Scaffold(
      appBar: customAppbar(
        context: context,
        title: getString(lblLoanCancellation),
        actions: [
          HelpCommonWidget(categoryval: HelpConstantData.categoryLoanCancellation,subCategoryval: HelpConstantData.subCategoryDetails,)
        ],
        onPressed: () {
          context.pop();
        },
      ),
      body: MFGradientBackground(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(getString(selectLCLoan),
                  style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 8.v),
              const LoanCancellationItemList(),
            ],
          ),
        ),
      ),
      floatingActionButton:
          BlocBuilder<LoanCancellationCubit, LoanCancellationState>(
        builder: (context, state) {
          return CustomElevatedButton(
            height: 42.v,
            width: 328.h,
            text: getString(lblLCProceed),
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
                    .bodyMedium!
                    .copyWith(color: AppColors.white)
                : Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: setColorBasedOnTheme(
                          context: context,
                          lightColor: AppColors.borderLight,
                          darkColor: AppColors.disableTextDark),
                    ),
            alignment: Alignment.bottomCenter,
            onPressed: () {
              if (state is SelectedLoanItemState) {
                context.pushNamed(Routes.loanCancelDetailScreen.name,
                    extra: state.loanItem);
              }
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  bool enableProceedButton(LoanCancellationState state) {
    if (state is SelectedLoanItemState) {
      return true;
    }
    return false;
  }
}
