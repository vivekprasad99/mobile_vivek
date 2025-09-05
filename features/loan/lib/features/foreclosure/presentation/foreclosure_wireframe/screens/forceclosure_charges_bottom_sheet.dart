import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/custom_elevated_button.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loan/features/foreclosure/data/models/get_loan_details_response.dart';
import 'package:core/config/resources/custom_outline_button.dart';
import '../../../../../config/routes/route.dart';

class ForceClosureChargesBottomSheet extends StatelessWidget {
  const ForceClosureChargesBottomSheet({super.key, this.loanDetails});

  final LoanDetails? loanDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,

      padding: const EdgeInsets.only(
          left: 24.0, right: 16.0, top: 16.0, bottom: 16.0),
      decoration:  BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28.0),
          topRight: Radius.circular(28.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5.v),
          Text(
            getString(msgForeclosureCharges),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 24.v),
          Container(
            width: 316.h,
            margin: EdgeInsets.only(right: 13.h),
            child: Text(
              getString(msgAsPerTheLoan),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          SizedBox(height: 34.v),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomOutlinedButton(
                  height: 48.v,
                  text: getString(lblBack),
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
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Expanded(
                child: CustomElevatedButton(
                  height: 48.v,
                  text: getString(lblProceed),
                  margin: EdgeInsets.only(left: 5.h),
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).highlightColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.h),
                    ),
                  ),
                  onPressed: () {
                    context.pushNamed(Routes.foreclosureDetail.name,
                        extra: loanDetails);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
