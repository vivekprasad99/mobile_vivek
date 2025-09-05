import 'package:core/config/resources/app_colors.dart';

import 'package:core/config/resources/custom_elevated_button.dart';

import 'package:core/config/resources/resources.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:flutter/material.dart';

import 'package:core/config/widgets/mf_appbar.dart';

import 'package:core/utils/size_utils.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/string_resource/Strings.dart';
import 'package:go_router/go_router.dart';
import 'package:profile/config/routes/route.dart';
import 'package:common/config/routes/route.dart' as common_routes;

class ProfileNameMismatchScreen extends StatefulWidget {
  final String errorMessage, errorTitle;
  const ProfileNameMismatchScreen(
      {required this.errorTitle, required this.errorMessage, super.key});

  @override
  State<ProfileNameMismatchScreen> createState() =>
      _ProfileNameMismatchScreenState();
}

class _ProfileNameMismatchScreenState extends State<ProfileNameMismatchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
          context: context,
          title: '',
          onPressed: () {
            Navigator.pop(context);
          }),
      body: MFGradientBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.error_outline,
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
              getString(lblNameMismatch),
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
                      Icon(Icons.error,
                          size: AppDimens.space16,
                          color: setColorBasedOnTheme(
                            context: context,
                            lightColor: AppColors.textFieldErrorColor,
                            darkColor: AppColors.sliderColor,
                          )),
                      SizedBox(
                        width: 8.v,
                      ),
                      Expanded(
                        child: Text(widget.errorTitle,
                            style: Theme.of(context).textTheme.titleSmall!),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12.v,
                  ),
                  Text(
                    widget.errorMessage,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomElevatedButton(
            onPressed: () {
              Navigator.of(context).popUntil(ModalRoute.withName(
                  common_routes.Routes.home.name));
              context.pushNamed(Routes.myProfileData.name);
            },
            text: getString(lblViewProfile),
            margin: EdgeInsets.only(left: 12.h, right: 12.h),
            buttonStyle: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).highlightColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.h),
              ),
            ),
          ),
          SizedBox(height: 16.v),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
