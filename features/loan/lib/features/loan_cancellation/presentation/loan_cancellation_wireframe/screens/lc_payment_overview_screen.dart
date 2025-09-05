import 'package:core/config/resources/custom_elevated_button.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loan/features/loan_cancellation/data/models/get_lc_list_response.dart';
import 'package:loan/features/loan_cancellation/data/models/get_loan_charges_request.dart';
import 'package:loan/features/loan_cancellation/presentation/cubit/loan_cancellation_cubit.dart';
import 'package:payment_gateway/config/routes/route.dart' as payment_routes;
import 'package:payment_gateway/features/domain/models/payment_model.dart';
import 'package:payment_gateway/features/domain/models/payment_params/payment_source_system.dart';
import 'package:payment_gateway/features/domain/models/payment_params/payment_product_type.dart';
import 'package:payment_gateway/features/domain/models/payment_params/payment_type.dart';
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';
class LoanCancellationPaymentOverviewScreen extends StatelessWidget {
  final LoanCancelItem loanDetails;
  const LoanCancellationPaymentOverviewScreen(
      {super.key, required this.loanDetails});

  @override
  Widget build(BuildContext context) {
    context.read<LoanCancellationCubit>().getLoanCharges(GetLoanChargesRequest(
        loanAccountNumber: loanDetails.loanAccountNumber));
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
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildForClosureBasicDetails(loanDetails, context),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Divider(
              color: Theme.of(context).dividerColor,
            ),
          ),
          BlocBuilder<LoanCancellationCubit, LoanCancellationState>(
            builder: (context, state) {
              if (state is LoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is GetLoanChargesSuccessState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: getString(msgAmountPayable),
                              style: Theme.of(context).textTheme.bodySmall),
                          TextSpan(
                              text: getString(msgPrincipleApplicationInterest),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400))
                        ],
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 4.v,
                    ),
                    Text(
                      "₹ ${state.response.totalCharges}",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(
                      height: 8.v,
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            ImageConstant.warning,
                            height: 16,
                            width: 16,
                          ),
                          SizedBox(
                            width: 8.h,
                          ),
                          Flexible(
                              child: Text(
                            getString(msgValueChangeSubject),
                            style: Theme.of(context).textTheme.labelSmall,
                          ))
                        ],
                      ),
                    ),
                  ],
                );
              }
              return Container();
            },
          ),
        ],
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<LoanCancellationCubit, LoanCancellationState>(
            builder: (context, state) {
              if (state is GetLoanChargesSuccessState) {
                return CustomElevatedButton(
                  height: 48.v,
                  text: getString(lblLCProceedToPay),
                  margin: EdgeInsets.only(left: 15.h, right: 15.h),
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).highlightColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.h),
                    ),
                  ),
                  onPressed: () {
                    context.pushNamed(
                      payment_routes.Routes.choosePaymentMode.name,
                      extra: PaymentModel(
                          productType: PaymentProductType.plNext,
                          sourceSystem: PaymentSourceSystem.pennant,
                          productNumber: loanDetails.loanAccountNumber ?? "",
                          paymentType: PaymentType.loancancel,
                          totalPaybleAmount:
                              state.response.totalCharges.toString(),
                          description: '',
                          fromScreen: 'loan_cancellation',
                      ),
                    );
                  },
                );
              }
              return Container();
            },
          ),
        ],
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
                  text: "${loanDetails?.productCategory.toString()} | ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(letterSpacing: 0.16)),
              TextSpan(
                  text: loanDetails?.loanAccountNumber.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(letterSpacing: 0.16)),
            ],
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 3.v),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(getString(lblLcLoanAmount),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).hintColor,
                      fontWeight: FontWeight.w400,
                    )),
            Text(
              " ₹${loanDetails?.totalAmount.toString()}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        )
      ],
    );
  }
}
