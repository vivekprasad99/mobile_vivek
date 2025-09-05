import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/custom_text_style.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:core/config/resources/custom_elevated_button.dart';

class FreezingPeriodBottomSheet extends StatelessWidget {
  const FreezingPeriodBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.only(left: 24.0,right: 16.0,top: 24.0,bottom: 16.0),
      margin: const EdgeInsets.only(top: 14, left: 12.0, right: 12.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
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
            getString(lblFreezingPeriod),
           style: Theme.of(context)
               .textTheme
               .headlineMedium,
          ),
          SizedBox(height: 24.v),
          Container(
            width: 316.h,
            margin: EdgeInsets.only(right: 13.h),
            child: Text(
              getString(msgFreezingPeriod),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: CustomTextStyles.bodyMediumGray70002.copyWith(
                height: 1.50,
              ),
            ),
          ),
          SizedBox(height: 34.v),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: CustomElevatedButton(
                  height: 48.v,
                  text:getString(lblOk),
                  margin: EdgeInsets.only(left: 5.h),
                  buttonStyle: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).highlightColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.h),
                      )),
                  buttonTextStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.white),
                  onPressed: () {
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
