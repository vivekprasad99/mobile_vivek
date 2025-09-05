import 'package:core/config/resources/custom_dropdown_button.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loan/config/routes/route.dart';
import 'package:loan/features/loan_cancellation/data/models/get_lc_list_response.dart';
import 'package:loan/features/loan_cancellation/data/models/get_lc_reasons_response.dart';
import 'package:loan/features/loan_cancellation/presentation/cubit/loan_cancellation_cubit.dart';
import 'package:loan/features/loan_cancellation/presentation/loan_cancellation_wireframe/widgets/lc_sr_status_check.dart';
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';

// ignore: must_be_immutable
class LoanCancellationDetailScreen extends StatelessWidget {
  LoanCancellationDetailScreen({super.key, this.loanDetails});
  final LoanCancelItem? loanDetails;
  CancelReasons? selectedReason;

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LoanCancellationCubit>(context).getReasons();
    return Scaffold(
        appBar: customAppbar(
          context: context,
          title: getString(lblLoanCancellation),
          onPressed: () {
            context.pop();
          },
          actions: [
           HelpCommonWidget(categoryval: HelpConstantData.categoryLoanCancellation,subCategoryval: HelpConstantData.subCategoryDetails,)
          ],
        ),
        body: MFGradientBackground(
          child: BlocBuilder<LoanCancellationCubit, LoanCancellationState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildForClosureBasicDetails(loanDetails, context),
                  _buildReasonDropdown(),
                  const Spacer(),
                  _proceedButtonWIdget(state, context)
                ],
              );
            },
          ),
        ));
  }

  Widget _proceedButtonWIdget(
      LoanCancellationState state, BuildContext context) {
    if (state is! LoadingState) {
      return MfCustomButton(
          onPressed: () {
            if (selectedReason == null) {
              return;
            }

            if (loanDetails?.productCategory?.toLowerCase() ==
                'personal loan') {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (_) => LCSrStatusCheck(
                  loanDetails: loanDetails,
                ),
              );
            } else {
              context.pushNamed(
                Routes.loanCancelFailureScreen.name,
                pathParameters: {'isNotPl': "true", 'isNotFlp': "false"},
              );
            }
          },
          isDisabled: selectedReason == null,
          text: getString(lblLCProceed),
          outlineBorderButton: false);
    }

    return Container();
  }

  SizedBox _buildReasonDropdown() {
    return SizedBox(
      width: double.infinity,
      child: BlocBuilder<LoanCancellationCubit, LoanCancellationState>(
        buildWhen: (previous, current) =>
            current is GetCancelReasonsSuccessState,
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GetCancelReasonsSuccessState) {
            List<CancelReasons>? reason = state.response;
            return CustomDropDownButton<CancelReasons>(
              isExpanded: true,
              hintText: getString(msgLcSelectReason),
              items: reason
                  .map(
                    (e) => DropdownMenuEntry<CancelReasons>(
                        label: e.name.toString(), value: e),
                  )
                  .toList(),
              onChanged: (value) {
                context
                    .read<LoanCancellationCubit>()
                    .selectReason(value ?? CancelReasons(), value?.name ?? "");

                selectedReason = value;
              },
              value: selectedReason,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildForClosureBasicDetails(
      LoanCancelItem? loanDetails, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: "${loanDetails!.productCategory.toString()} | ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(letterSpacing: 0.16)),
              TextSpan(
                  text: loanDetails.productName ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(letterSpacing: 0.16)),
            ],
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 4.v),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(getString(lblLcLoanAmount),
                style: Theme.of(context).textTheme.labelMedium),
            Text(
              " ₹${loanDetails.totalAmount.toString()}",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Divider(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ],
    );
  }
}
