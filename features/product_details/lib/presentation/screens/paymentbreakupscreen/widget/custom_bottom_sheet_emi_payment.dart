import 'package:auth/features/login_and_registration/presentation/login_wireframe/widgets/custom_elevated_button.dart';
import 'package:auth/features/login_and_registration/presentation/login_wireframe/widgets/custom_outlined_button.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:product_details/utils/services.dart';

customBottomSheetForEMIPayment(
  BuildContext context, {
  required String payableAmount,
  required String payingAmount,
  required String excessAmount,
  required String description,
  required String primaryButtonTitle,
  required String secondaryButtonTitle,
  required VoidCallback primaryCallback,
  required VoidCallback secondaryCallback,
  required VoidCallback resetCallBack,
  bool caseOneDesign = false,
}) {
  showModalBottomSheet<void>(
    backgroundColor: Theme.of(context).cardColor,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      excessAmount = double.parse(excessAmount).toStringAsFixed(2);
      return SizedBox(
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28.0))),
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
            horizontal: 16.h,
            vertical: 24.v,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                getString(lblPaymentConfirmation),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                height: 24.v,
              ),
              if (!caseOneDesign) ...[
                paymentAmountRowWidget(
                  context,
                  label: getString(lblAmountPayable),
                  amount: payableAmount,
                ),
                SizedBox(height: 12.v),
                paymentAmountRowWidget(
                  context,
                  label: getString(lblAmountPaying),
                  amount: payingAmount,
                ),
                SizedBox(height: 12.v),
                Divider(
                  height: 1.h,
                  color: AppColors.primaryLight6,
                ),
                SizedBox(height: 12.v),
                paymentAmountRowWidget(context,
                    label: getString(lblExcessAmount),
                    amount: rupeeFormatter(excessAmount),
                    style: Theme.of(context).textTheme.bodyMedium),
                SizedBox(
                  height: 16.v,
                ),
              ],
              Text(
                description,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              SizedBox(height: 24.v),
              CustomElevatedButton(
                height: 48.v,
                text:  primaryButtonTitle,
                buttonStyle: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).highlightColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.h),
                  ),
                ),
                buttonTextStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.white),
                onPressed: primaryCallback,
              ),
              SizedBox(
                height: 16.v,
              ),
              CustomOutlinedButton(
                height: 48.v,
                text: secondaryButtonTitle,
                margin: EdgeInsets.only(right: 5.h),
                buttonStyle: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.secondaryLight,
                      darkColor: AppColors.secondaryLight5,
                    ),
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.h),
                  ),
                ),
                buttonTextStyle:
                    Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: setColorBasedOnTheme(
                          context: context,
                          lightColor: AppColors.secondaryLight,
                          darkColor: AppColors.secondaryLight5,
                        )),
                onPressed: secondaryCallback,
              ),
            ],
          ),
        ),
      );
    },
  ).then((value) {
    resetCallBack();
  });
}

Widget paymentAmountRowWidget(
  BuildContext context, {
  required String label,
  required String amount,
  TextStyle? style,
}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: style ?? Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            rupeeFormatter(amount),
            style: style ?? Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    ],
  );
}
