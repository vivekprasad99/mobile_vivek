import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/app_dimens.dart';
import 'package:core/config/resources/custom_elevated_button.dart';
import 'package:core/config/string_resource/Strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

class ServiceRequestScreen extends StatelessWidget {
  const ServiceRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MFGradientBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 64.v,
            ),
            Icon(
              Icons.confirmation_num_outlined,
              size: AppDimens.space50,
              color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.secondaryLight,
                  darkColor: AppColors.primaryLight5),
            ),
            SizedBox(
              height: 16.v,
            ),
            Text(
              getString(lblServiceRequestGenerated),
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle,
                          size: AppDimens.space16,
                          color: setColorBasedOnTheme(
                            context: context,
                            lightColor: AppColors.successGreenColor,
                            darkColor: AppColors.myServiceRequestCheck,
                          )),
                      SizedBox(
                        width: 8.v,
                      ),
                      Text("Service ticket #62843092",
                          style: Theme.of(context).textTheme.titleSmall!),
                      SizedBox(
                        width: 4.v,
                      ),
                      Icon(
                        Icons.file_copy,
                        size: AppDimens.space16,
                        color: Theme.of(context).unselectedWidgetColor,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12.v,
                  ),
                  Text(
                    "We've taken your address change request. Our team is currently reviewing it and will reach out to you shortly",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomElevatedButton(
            height: 48.v,
            text: getString(lblHome),
            isDisabled: false,
            margin: EdgeInsets.only(left: 15.h, right: 15.h),
            buttonStyle: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).highlightColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.h),
              ),
            ),
            onPressed: () {
              context.pop();
              context.pop();
              context.pop();
            },
          ),
        ],
      ),
    );
  }
}
