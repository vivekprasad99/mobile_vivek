import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/custom_elevated_button.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/routes/app_route_cubit.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lead_generation/config/routes/route.dart';

class AcknowledgementWidget extends StatelessWidget {
  const AcknowledgementWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: MFGradientBackground(
          horizontalPadding: 16,
          verticalPadding: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50.v),
              SvgPicture.asset(
                ImageConstant.imgCongratulationIcon,
                height: 88.v,
                width: 48.h,
                colorFilter: ColorFilter.mode(
                    setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.secondaryLight,
                        darkColor: AppColors.primaryLight5),
                    BlendMode.srcIn),
              ),
              SizedBox(height: 17.v),
              Text(
                getString(msgThankYouTitle),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 17.v),
              Container(
                height: 40.v,
                width: 328.h,
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, top: 16.0, bottom: 8.0),
                  child: Text(
                    getString(msgThankYouSubTitle),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ),
              SizedBox(height: 17.v),

              SizedBox(height: 50.v),
              const Spacer(),
              SizedBox(height: 10.v),
              CustomElevatedButton(
                  text: getString(lblHome),
                  rightIcon: Container(
                    margin: EdgeInsets.only(left: 24.h),
                  ),
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
                    context
                        .read<AppRouteCubit>()
                        .navigateToHomeScreen(from: Routes.acknowledge.path);
                  }),
              SizedBox(height: 20.v),
            ],
          ),
        ),
      ),
    );
  }
}
