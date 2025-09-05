import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:common/config/routes/route.dart' as common_routes;

class VisitNearestBranch extends StatelessWidget {
  const VisitNearestBranch({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: MFGradientBackground(
        horizontalPadding: 12.v,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.error_outline,
              size: 56.v,
              color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.secondaryLight,
                  darkColor: AppColors.primaryLight5),
            ),
            SizedBox(
              height: 12.h,
            ),
            Text(
              getString(msgVisitNearestBranch),
              style: Theme.of(context).textTheme.headlineLarge,
            )
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.v),
        child: MfCustomButton(
          onPressed: () {
            while (context.canPop()) {
              context.pop();
            }
            context.pushReplacementNamed(
              common_routes.Routes.home.name,
            );
          },
          text: getString(lblHome),
          outlineBorderButton: false,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
