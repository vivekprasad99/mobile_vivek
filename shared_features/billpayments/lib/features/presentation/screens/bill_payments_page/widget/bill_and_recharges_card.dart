import 'package:billpayments/features/data/models/bill_payment_request.dart';
import 'package:billpayments/features/presentation/cubit/bill_payments_cubit.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/Strings.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BillAndRechargesCard extends StatelessWidget {
  const BillAndRechargesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              8.h,
            ),
            color: Theme.of(context).cardColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(getString(lblBillsRecharge),
                style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8.h),
            Text(getString(msgPayYourBills),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(letterSpacing: 0.16)),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    BillPaymentRequest request =
                        BillPaymentRequest(mobileNumber: getPhoneNumber());
                    BlocProvider.of<BillPaymentsCubit>(context)
                        .getBbpsUrl(request);
                  },
                  child: Row(
                    children: [
                      Text(getString(lblPayNow),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: setColorBasedOnTheme(
                                        context: context,
                                        lightColor: AppColors.secondaryLight,
                                        darkColor: AppColors.secondaryLight5),
                                  )),
                      Icon(Icons.arrow_forward_ios_outlined,
                          size: 12.h,
                          color: setColorBasedOnTheme(
                              context: context,
                              lightColor: AppColors.secondaryLight,
                              darkColor: AppColors.secondaryLight5))
                    ],
                  ),
                ),
                Image.asset(
                  brightness == Brightness.light
                      ? ImageConstant.imgBillPaymentIconLight
                      : ImageConstant.imgBillPaymentIconDark,
                )
              ],
            ),
          ],
        ));
  }
}
