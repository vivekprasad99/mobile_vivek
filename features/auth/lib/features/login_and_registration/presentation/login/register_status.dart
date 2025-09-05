import 'package:auth/config/routes/route.dart';
import 'package:auth/features/login_and_registration/presentation/cubit/auth_cubit.dart';
import 'package:auth/features/login_and_registration/presentation/cubit/auth_state.dart';
import 'package:common/features/startup/data/models/validate_device_response.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/app_dimens.dart';
import 'package:core/config/string_resource/Strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../login_wireframe/widgets/custom_elevated_button.dart';
// ignore_for_file: must_be_immutable
class RegisterStatus extends StatelessWidget {
  bool? registerStatus;

  RegisterStatus({super.key, this.registerStatus});

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var middleNameController = TextEditingController();
  bool enableVerifyBtn = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
      Future.delayed(Duration(seconds: registerStatus! ? 4 : 10), () {
        if (registerStatus!) {
          context.goNamed(Routes.mpin.name, extra: Profiles());
        } else {
          context.goNamed(Routes.mobileOtp.name);
        }
      });

    return  SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: MFGradientBackground(
            child:  Padding(
              padding:  const EdgeInsets.fromLTRB(16,60,16,16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (registerStatus != null && !registerStatus!)
                    Icon(Icons.error_outline_rounded,
                        color: setColorBasedOnTheme(
                            context: context,
                            lightColor: AppColors.secondaryLight,
                            darkColor: AppColors.primaryLight5),
                        size: AppDimens.displayMedium),
                  SizedBox(height:15.h),
                  Text(
                    registerStatus!
                        ? getString(msgRegistrationSuccessTitle)
                        : getString(registrationFailed),
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                  ),
                  registerStatus!
                      ?   Text(getString(msgRegistrationSuccessDesc),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).hintColor,fontSize: AppDimens.titleLarge)

                  ): Container(
                    padding: const EdgeInsets.only(top: 16,right: 16),
                    margin: const EdgeInsets.only(top: 10),
                    decoration:  BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: const BorderRadius.all(Radius.circular(8))),
                    child: RichText(text:  TextSpan(
                        children: [
                          TextSpan(
                              text: getString(msgRegistrationFailDesc1),
                              style: Theme.of(context).textTheme.labelSmall
                          ),
                          TextSpan(
                              text: getString(msgRegistrationFailDesc2),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).highlightColor)
                          ),
                          TextSpan(
                              text: getString(msgRegistrationFailDesc3),
                              style: Theme.of(context).textTheme.labelSmall
                          )
                        ]
                    )),
                  ),
                  const Spacer(),
                  CustomElevatedButton(
                      onPressed: () {
                        context.goNamed(Routes.mobileOtp.name);
                      },
                      text: registerStatus!
                          ? getString(lblContinue)
                          : getString(lblRetry),
                      margin: EdgeInsets.symmetric(horizontal: 3.h),
                      buttonStyle: ElevatedButton.styleFrom(
                          backgroundColor:
                          Theme.of(context).highlightColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          )),
                      buttonTextStyle:
                      Theme.of(context).textTheme.bodyMedium
                  )
                ],
              ),
            ),
          ),
        ),
      );

});
  }


}
