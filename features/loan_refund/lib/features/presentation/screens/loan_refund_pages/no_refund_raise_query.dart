import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:service_ticket/config/routes/route.dart' as service_ticket_routes;
import 'package:common/config/routes/route.dart' as common;
import 'package:common/config/routes/app_route.dart';
import 'package:service_ticket/features/presentation/helper/services_type.dart';
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';
class NoRefundRaiseQuery extends StatelessWidget {
  const NoRefundRaiseQuery({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
          context: context,
          title: getString(
            lblRaiseFund,
          ),
          onPressed: () {
            context.pop();
          },
          actions: [
            HelpCommonWidget(categoryval: HelpConstantData.categoryRefund,subCategoryval: HelpConstantData.categoryRefund,)
          ]
      ),
      body: MFGradientBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50.0, right: 20.0),
                    child: SizedBox(
                      child: SvgPicture.asset(
                        height: 60.adaptSize,
                        width: 40.adaptSize,
                        ImageConstant.imgRefundQueryCamera ,
                      ),
                    ),
                  ),
                  SizedBox(
                      height: 101.v,
                      width: 200.v,
                      child: Text(getString(lblnoexcessfundmsg))),
                ],
              ),
            ),
            homeButton(context),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                context.pushNamed(service_ticket_routes.Routes.raiseRequest.name, extra: {'type': Services.refund.value, 'id': '1'});
              },
              child: Text(
                getString(lblRaiseQuery),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.secondaryLight,
                        darkColor: AppColors.white),
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}

Widget homeButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: MfCustomButton(
      onPressed: () {
        while (AppRoute.router.canPop()) {
          AppRoute.router.pop();
        }
        context.pushReplacementNamed(common.Routes.home.name);
      },
      text: getString(lblHome),
      outlineBorderButton: false,
      textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: setColorBasedOnTheme(
              context: context,
              lightColor: AppColors.white,
              darkColor: AppColors.white),
          fontWeight: FontWeight.w400,
          fontSize: 14.0),
    ),
  );
}
