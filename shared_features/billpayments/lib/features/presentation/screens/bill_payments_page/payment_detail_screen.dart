import 'package:billpayments/features/presentation/cubit/bill_payments_cubit.dart';
import 'package:billpayments/features/presentation/utils/services.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:core/utils/size_utils.dart';
import 'package:auth/features/login_and_registration/presentation/login_wireframe/widgets/custom_floating_text_field.dart';
import 'package:auth/features/login_and_registration/presentation/login_wireframe/widgets/custom_elevated_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payment_gateway/features/presentation/utils/extensions.dart';
import 'package:payment_gateway/features/presentation/widgets/appbar.dart';



class PaymentDetailScreen extends StatefulWidget {
 const PaymentDetailScreen({super.key});

  @override
  State<PaymentDetailScreen> createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends State<PaymentDetailScreen> {
  final TextEditingController amountController = TextEditingController();

  bool showAmountWarning = false;
  bool showMoreDetails = false;
  bool isAmountInvalid = true;

  final GlobalKey paymentButtonKey = GlobalKey();

  @override
  void initState() {
    // amountController.text =
    //     inputFiledAmountFormatter(PaymentConstants.emiAmount.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: buildCustomAppBar(
              context: context, title: getString(lblPaymentOptions)),
          body: MFGradientBackground(
            verticalPadding: 0.h,
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 16.h,
                      ),
                      Text(
                        "Vehicle loan | PVL 12457898",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        "Mahindra XUV 700 | MA 02 XY 1234",
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  letterSpacing: 0.06,
                                  height: 18 / 14,
                                ),
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      Divider(
                        height: 1.h,
                        color: Theme.of(context).dividerColor,
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      _buildAmountInputField(context),
                      SizedBox(
                        height: 5.h,
                      ),
                      BlocBuilder<BillPaymentsCubit, BillPaymentsState>(
                        buildWhen: (previous, current) =>
                            current is PayableAmountValidationState,
                        builder: (context, state) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(left: 12.0, right: 12),
                            child: Text(
                                isAmountInvalid
                                    ? "Rupees twenty-four thousand four hundred and fifty this  how it will look if two sentences."
                                    : getString(lblMinAmountCannotBeLess),
                                style: isAmountInvalid
                                    ? Theme.of(context).textTheme.labelSmall
                                    : Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                            color:
                                                AppColors.textFieldErrorColor)),
                          );
                        },
                      ),
                      BlocBuilder<BillPaymentsCubit, BillPaymentsState>(
                        builder: (context, state) {
                          if (state is ShowAmountWarningState) {
                            showAmountWarning = state.showAmountWarning;
                          }
                          return showAmountWarning
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                            ImageConstant.errorIcon,
                                            height: 16.v,
                                            width: 16.h,
                                          ),
                                          SizedBox(
                                            width: 8.h,
                                          ),
                                          Expanded(
                                              child: Text(
                                            "You are choosing to not proceed with closing the loan Account.  Total amount payable should not be more than ₹60,450.\n(current Total + Total outstanding/pending amount (future EMIs) + charges )",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall,
                                          )),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox();
                        },
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      _amountBreakupWidget(),
                      Expanded(
                          child: SizedBox(
                        height: 10.h,
                      )),
                      BlocBuilder<BillPaymentsCubit, BillPaymentsState>(
                        buildWhen: (previous, current) =>
                            current is PayableAmountValidationState,
                        builder: (context, state) {
                          return CustomElevatedButton(
                            key: paymentButtonKey,
                            onPressed: isAmountInvalid
                                ? () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();

                                        // validateAndNavigate();
                                  }
                                : null,
                            text: getString(lblProceedToPay),
                            margin: EdgeInsets.symmetric(horizontal: 3.h),
                            buttonStyle: ElevatedButton.styleFrom(
                                backgroundColor: isAmountInvalid
                                    ? Theme.of(context).highlightColor
                                    : Theme.of(context).disabledColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.h),
                                )),
                            buttonTextStyle: isAmountInvalid
                                ? Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: AppColors.white)
                                : Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .unselectedWidgetColor),
                          );
                        },
                      ),
                      SizedBox(
                        height: 24.h,
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  // void validateAndNavigate() {
  //   if (showAmountWarning) {
  //     context.read<BillPaymentsCubit>().setAmountWarningVisibilty(false);
  //   }

  //   num enteredAmount = getAmountAsDouble(amountController.text);

  //   bool case1 = (enteredAmount > PaymentConstants.forcloserAmount) &&
  //       (enteredAmount > PaymentConstants.emiAmount);

  //   bool case2 = (PaymentConstants.emiAmount < enteredAmount) &&
  //       (enteredAmount < PaymentConstants.forcloserAmount);

  //   bool case3 = (PaymentConstants.minimumPayableAmount < enteredAmount) &&
  //       (enteredAmount < PaymentConstants.emiAmount);
  //   if (case1 || case2 || case3) {
  //     customBottomSheetForEMIPayment(
  //       context,
  //       caseOneDesign: case1,
  //       payableAmount: PaymentConstants.emiAmount.toString(),
  //       payingAmount: enteredAmount.toString(),
  //       excessAmount:
  //           (enteredAmount - PaymentConstants.emiAmount).abs().toString(),
  //       description: case1
  //           ? "₹74,450.00 is more than the foreclosure amount ₹60,450.00. \n\nDo you wish to proceed?"
  //           : case2
  //               ? getString(msgExcessWillBeAdjusted)
  //               : getString(msgChargesMightAccumulateDues),
  //       primaryCallback: () {
  //         Navigator.of(context).pop();
  //         if (case1) {
  //           context.read<BillPaymentsCubit>().setAmountWarningVisibilty(true);
  //         }
  //       },
  //       secondaryCallback: () {
  //         Navigator.of(context).pop();
  //         context.pushNamed(Routes.choosePaymentMode.name);
  //       },
  //     );
  //     return;
  //   }
  //   context.pushNamed(Routes.choosePaymentMode.name);
  // }

  Widget _buildAmountInputField(BuildContext context) {
    return BlocListener<BillPaymentsCubit, BillPaymentsState>(
      listener: (context, state) {
        if (state is PayableAmountValidationState) {
          isAmountInvalid = state.isAmountValid;
        }
      },
      child: CustomFloatingTextField(
        onChange: (amount) {
          amountController.text = inputFiledAmountFormatter(amount);

          context
              .read<BillPaymentsCubit>()
              .setPayableAmountValidation(amount);
        },
        onTap: () async {
          if (paymentButtonKey.currentContext != null) {
            await Future.delayed(const Duration(milliseconds: 500));
            RenderObject? object =
                paymentButtonKey.currentContext!.findRenderObject();
            if (object != null) {
              object.showOnScreen();
            }
          }
        },
        autofocus: false,
        controller: amountController,
        textStyle: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(fontWeight: FontWeight.w400),
        labelText: getString(lblAmountPayable),
        labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              letterSpacing: 0.06,
            ),
        textInputAction: TextInputAction.done,
        textInputType: TextInputType.number,
        borderDecoration: UnderlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: Theme.of(context).unselectedWidgetColor,
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget _amountBreakupWidget() {
    return BlocBuilder<BillPaymentsCubit, BillPaymentsState>(
      buildWhen: (previous, current) => current is AmountDetailsState,
      builder: (context, state) {
        if (state is AmountDetailsState) {
          showMoreDetails = state.showMoreDetails;
        }
        final Brightness brightness = Theme.of(context).brightness;
        return Container(
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getString(lblBreakUp),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(
                  height: 12.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getString(lblCurrentEMIOverdue),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      RupeeFormatter(22000).inRupeesFormat(),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
                SizedBox(
                  height: 12.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(getString(lblOverDueFromPrevEMI),
                        style: Theme.of(context).textTheme.bodySmall),
                    Text(RupeeFormatter(220097).inRupeesFormat(),
                        style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
                SizedBox(
                  height: 12.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        context
                            .read<BillPaymentsCubit>()
                            .showAmountDetails(!showMoreDetails);
                      },
                      child: Row(
                        children: [
                          Text(getString(lblCharges),
                              style: Theme.of(context).textTheme.bodySmall),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(getString(lblDetails),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      color: brightness == Brightness.light
                                          ? AppColors.secondaryLight
                                          : AppColors.secondaryLight5)),
                          Icon(
                            showMoreDetails
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: brightness == Brightness.light
                                ? AppColors.secondaryLight
                                : AppColors.secondaryLight5,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      RupeeFormatter(1000).inRupeesFormat(),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
                SizedBox(
                  height: 12.h,
                ),
                if (showMoreDetails) ...[
                  _chargesDetailsWidget(context,
                      label: getString(lblReturnCharges),
                      amount: RupeeFormatter(100).inRupeesFormat(),
                      subLabel: "Lorem ipsum simple dummy text"),
                  SizedBox(
                    height: 12.h,
                  ),
                  _chargesDetailsWidget(context,
                      label: getString(lblLegalCharges),
                      amount: RupeeFormatter(100).inRupeesFormat(),
                      subLabel: "Lorem ipsum simple dummy textLorem ipsum "),
                  SizedBox(
                    height: 12.h,
                  ),
                  _chargesDetailsWidget(context,
                      label: getString(lblOtherCharges),
                      amount: RupeeFormatter(1234).inRupeesFormat(),
                      subLabel: "Lorem ipsum simple dummy text"),
                  SizedBox(
                    height: 12.h,
                  ),
                ],
                Divider(
                  height: 1.h,
                  color: AppColors.primaryLight6,
                ),
                SizedBox(
                  height: 12.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(getString(lblTotal),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    Text(
                      RupeeFormatter(100).inRupeesFormat(),
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Column _chargesDetailsWidget(BuildContext context,
      {required String label,
      required String amount,
      required String subLabel}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child:
                    Text(label, style: Theme.of(context).textTheme.bodySmall)),
            Text(amount, style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
        const SizedBox(
          height: 2,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 50.0),
          child: Text(subLabel, style: Theme.of(context).textTheme.labelSmall),
        )
      ],
    );
  }
}
