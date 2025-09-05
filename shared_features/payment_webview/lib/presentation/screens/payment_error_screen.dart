import 'package:core/config/config.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/features/presentation/bloc/theme/theme_bloc.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentErrorScreen extends StatefulWidget {
  const PaymentErrorScreen({super.key});

  @override
  State<PaymentErrorScreen> createState() =>
      _PaymentErrorScreenState();
}

class _PaymentErrorScreenState
    extends State<PaymentErrorScreen> {
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
                  Icon(
                    Icons.error,
                    size: 56,
                    color: setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.secondaryLight,
                      darkColor: AppColors.secondaryLight5,
                    ),
                  ),
                  SizedBox(height: 20.v),
                  Text(getString(msgErrorRequired),
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
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
