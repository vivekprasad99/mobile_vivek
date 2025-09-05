import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/custom_elevated_button.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/features/presentation/bloc/theme/theme_bloc.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

class NetworkDownScreen extends StatefulWidget {
  const NetworkDownScreen({super.key});

  @override
  State<NetworkDownScreen> createState() =>
      _InternetConnectivityScreenState();
}

class _InternetConnectivityScreenState
    extends State<NetworkDownScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeData>(builder: (context, state) {
      return Scaffold(
        body: MFGradientBackground(
            horizontalPadding: 8,
            verticalPadding: 8,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 100.v),
                  Icon(
                    Icons.error_outline_outlined,
                    size: 56,
                    color: setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.secondaryLight,
                      darkColor: AppColors.secondaryLight5,
                    ),
                  ),
                  SizedBox(height: 20.v),
                  Text(getString(msgNetworkDown),
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.w600,
                              color: setColorBasedOnTheme(
                                  context: context,
                                  lightColor: AppColors.primaryLight,
                                  darkColor: AppColors.white,),),),
                  SizedBox(height: 20.v),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 16.0,),
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),),
                    child: Column(children: [
                      Row(children: [
                        Icon(
                          Icons.phone_android,
                          size: 30,
                          color: setColorBasedOnTheme(
                            context: context,
                            lightColor: AppColors.secondaryLight,
                            darkColor: AppColors.secondaryLight5,
                          ),
                        ),
                        SizedBox(width: 10.h,),
                        Text(getString(lblCustomerCare),
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.w600,
                                color: setColorBasedOnTheme(
                                    context: context,
                                    lightColor: AppColors.textFieldErrorColor,
                                    darkColor: AppColors.backgroundLight5,),),),
                      ],),
                      SizedBox(height: 7.h),
                      Divider(
                        color: setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.primaryLight6,
                        darkColor: AppColors.shadowDark,
                      ),
                        thickness: 1,
                        indent : 10,
                        endIndent : 10,
                      ),
                      SizedBox(height: 7.h),
                      Row(children: [
                        Icon(
                          Icons.email_outlined,
                          size: 30,
                          color: setColorBasedOnTheme(
                            context: context,
                            lightColor: AppColors.secondaryLight,
                            darkColor: AppColors.secondaryLight5,
                          ),
                        ),
                        SizedBox(width: 10.h,),
                        Text(getString(lblEmailUs),
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.w600,
                                color: setColorBasedOnTheme(
                                    context: context,
                                    lightColor: AppColors.textFieldErrorColor,
                                    darkColor: AppColors.backgroundLight5,),),),
                      ],),
                    ],),
                  ),
                  const Spacer(),
                  CustomElevatedButton(
                      height: 42.h,
                      onPressed: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) => exit(0));
                      },
                      text: getString(lblContinueOnWeb),
                      margin: EdgeInsets.symmetric(horizontal: 3.h),
                      buttonStyle: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).highlightColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.h),
                          ),),
                      buttonTextStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.white),),
                  SizedBox(height: 20.v),
                ],
              ),
            ),
          ),
      );
    },);
  }
}
