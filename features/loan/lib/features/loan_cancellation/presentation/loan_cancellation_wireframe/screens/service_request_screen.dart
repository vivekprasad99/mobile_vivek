import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/app_dimens.dart';
import 'package:core/config/resources/custom_elevated_button.dart';
import 'package:core/config/resources/custom_outline_button.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loan/features/loan_cancellation/data/models/create_sr_response.dart';
import 'package:common/config/routes/route.dart' as common_routes;

class ServiceRequestScreen extends StatelessWidget {
  final CreateSrData createSrData;
  const ServiceRequestScreen({super.key, required this.createSrData});

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
            SvgPicture.asset(
              ImageConstant.congratulationIcon,
              colorFilter: ColorFilter.mode(
                  setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.secondaryLight,
                      darkColor: AppColors.primaryLight5),
                  BlendMode.srcIn),
            ),
            SizedBox(
              height: 16.v,
            ),
            Text(
              getString(msgServiceRequest),
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
                      SvgPicture.asset(ImageConstant.checkCircleFilled),
                      SizedBox(
                        width: 8.v,
                      ),
                      Text(
                        "${getString(lblServiceTicket)} #${createSrData.serviceTicketNumber}",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontSize: 14),
                      ),
                      SizedBox(
                        width: 4.v,
                      ),
                      SvgPicture.asset(
                        ImageConstant.fileCopy,
                        colorFilter: ColorFilter.mode(
                            setColorBasedOnTheme(
                                context: context,
                                lightColor: AppColors.secondaryLight,
                                darkColor: AppColors.white),
                            BlendMode.srcIn),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12.v,
                  ),
                  Text(
                    getString(msgExecLookingWillContect),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(
                    height: 10.v,
                  ),
                  Text(
                    getString(msgRequestStatusAfterhours),
                    style: Theme.of(context).textTheme.bodyMedium,
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
            text: getString(lblLcTrackSrStatus),
            margin: EdgeInsets.only(left: 15.h, right: 15.h),
            buttonStyle: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).highlightColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.h),
              ),
            ),
            onPressed: () {},
          ),
          SizedBox(
            height: 15.v,
          ),
          CustomOutlinedButton(
            height: 48.v,
            text: getString(lblHome),
            margin: EdgeInsets.only(right: 15.h, left: 15.h),
            buttonStyle: OutlinedButton.styleFrom(
              side: BorderSide(
                color: setColorBasedOnTheme(
                    context: context,
                    lightColor: AppColors.secondaryLight,
                    darkColor: AppColors.secondaryLight5),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.h),
              ),
            ),
            buttonTextStyle: TextStyle(
              fontSize: AppDimens.titleSmall,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1,
              color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.secondaryLight,
                  darkColor: AppColors.secondaryLight5),
            ),
            onPressed: () {
              while (context.canPop()) {
                context.pop();
              }
              context.pushReplacementNamed(
                common_routes.Routes.home.name,
              );
            },
          ),
        ],
      ),
    );
  }
}
