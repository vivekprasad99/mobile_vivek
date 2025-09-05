import 'package:auth/features/login_and_registration/presentation/login_wireframe/widgets/custom_elevated_button.dart';
import 'package:auth/features/login_and_registration/presentation/login_wireframe/widgets/custom_outlined_button.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';

showCustomBottomSheetPayment(
  BuildContext context, {
  required String title,
  required String description,
  String? primaryButtonTitle,
  String? secondaryButtonTitle,
  VoidCallback? onPrimaryButtonClick,
  VoidCallback? onSecondaryButtonClick,
  VoidCallback? skipOnclick,
}) {
  showModalBottomSheet<void>(
    backgroundColor: Theme.of(context).cardColor,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
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
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                height: 16.v,
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              SizedBox(height: 24.v),
              if (primaryButtonTitle != null)
                CustomElevatedButton(
                  height: 48.v,
                  text: primaryButtonTitle,
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
                  onPressed: onPrimaryButtonClick,
                ),
              SizedBox(
                height: 16.v,
              ),
              if (secondaryButtonTitle != null)
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
                  onPressed: onSecondaryButtonClick,
                ),
              if (skipOnclick != null)
                Center(
                  child: Text(
                    getString(lblSkip),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}

