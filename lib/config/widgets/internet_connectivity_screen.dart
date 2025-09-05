import 'package:core/config/config.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/custom_elevated_button.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/features/presentation/bloc/theme/theme_bloc.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_settings_plus/core/open_settings_plus.dart';
import 'dart:io';

class InternetConnectivityScreen extends StatefulWidget {
  const InternetConnectivityScreen({super.key});

  @override
  State<InternetConnectivityScreen> createState() =>
      _InternetConnectivityScreenState();
}

class _InternetConnectivityScreenState
    extends State<InternetConnectivityScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeData>(builder: (context, state) {
      return Scaffold(
        body: Theme(
          data: state == ThemeData.dark()
              ? themeDark(context)
              : themeLight(context),
          child: MFGradientBackground(
            horizontalPadding: 8,
            verticalPadding: 8,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 100.v),
                  SvgPicture.asset(
                  colorFilter: ColorFilter.mode(
                      setColorBasedOnTheme(
                          context: context,
                          lightColor: AppColors.secondaryLight,
                          darkColor: AppColors.primaryLight5),
                      BlendMode.srcIn),
                      ImageConstant.wifiIconOff,
                      height: 56.adaptSize,
                      width: 56.adaptSize,
                    ),
                  SizedBox(height: 20.v),
                  Text(getString(msgInternetRequired),
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.w600,
                              color: setColorBasedOnTheme(
                                  context: context,
                                  lightColor: AppColors.primaryLight,
                                  darkColor: AppColors.white))),
                  SizedBox(height: 20.v),
                  Container(
                    width: 328.h,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 16.0),
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    child: Text(getString(msgWifiEnable),
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                                fontFamily: "Karla",
                                fontWeight: FontWeight.w400,
                                color: setColorBasedOnTheme(
                                    context: context,
                                    lightColor: AppColors.textLight,
                                    darkColor: AppColors.white))),
                  ),
                  const Spacer(),
                  CustomElevatedButton(
                      height: 42.h,
                      onPressed: () {
                        if(Platform.isAndroid){
                          const OpenSettingsPlusAndroid().wifi();
                        } else {
                          const OpenSettingsPlusIOS().settings();
                        }
                      },
                      text: getString(lblOpenSetting),
                      margin: EdgeInsets.symmetric(horizontal: 3.h),
                      buttonStyle: ElevatedButton.styleFrom(
                          backgroundColor: setColorBasedOnTheme(
                            context: context,
                            lightColor: AppColors.secondaryLight,
                            darkColor: AppColors.secondaryLight5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.h),
                          )),
                      buttonTextStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.white)),
                  SizedBox(height: 20.v),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
