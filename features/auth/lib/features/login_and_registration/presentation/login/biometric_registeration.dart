import 'package:common/features/startup/data/models/validate_device_response.dart';
import 'package:core/config/config.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:core/config/widgets/action_buttons/custom_switch_button.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:open_settings_plus/core/open_settings_plus.dart';

import '../../../../config/routes/route.dart';
import '../cubit/biometric_cubit.dart';
import '../cubit/biometric_state.dart';
import 'dart:io';

import '../login_wireframe/widgets/custom_elevated_button.dart';
import 'package:help/features/utils/help_common_widget.dart';
import 'package:help/features/utils/constant_help.dart';

// ignore_for_file: must_be_immutable
class BiometricRegistrationScreen extends StatefulWidget {
  bool? isFromSetting;
  BiometricRegistrationScreen({super.key, this.isFromSetting});

  @override
  State<BiometricRegistrationScreen> createState() =>
      _BiometricRegistrationScreenState();
}

class _BiometricRegistrationScreenState
    extends State<BiometricRegistrationScreen> with WidgetsBindingObserver {
  bool isFaceIdEnable = false;
  // bool isFingerPrintEnable = false;
  bool enableBioMetricButton = false;
  List<BiometricType> availableBiometrics = [];
  bool isFacedId=false;
  bool isDeviceHasBiometric = false;
  bool isAuthSuccess = false;

  @override
  void initState() {
    if (widget.isFromSetting == false) {
      customShowToast(
          containerColor: Colors.white,
          msg: getString(msgMpinSuccessSet),
          icon: Icons.check_circle_outline,
          iconColor: Colors.green,
          bottomPadding: 85);
    }
    context.read<BiometricCubit>().getAvailableBiometric(Platform.isAndroid);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<BiometricCubit>().getAvailableBiometric(Platform.isAndroid);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:  Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: widget.isFromSetting == true ? IconButton(
          icon: const Icon(Icons.arrow_back),
          color: setColorBasedOnTheme(
              context: context,
              lightColor: AppColors.secondaryLight,
              darkColor: AppColors.backgroundLight5),
          onPressed: () {
            context.pop(true);
          },
        ) : Container(),
        toolbarHeight: 64.h,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [HelpCommonWidget(categoryval: HelpConstantData.categoryRegistration,subCategoryval: HelpConstantData.subCategoryBiometrics)],
      ),
      body: MFGradientBackground(

        verticalPadding: 0.0,
        child: BlocConsumer<BiometricCubit, Biometric>(
          listener: (context, state) {
            if(state is BiometricTypeFaceId) {
              availableBiometrics= state.availableBiometrics;
              isFacedId= state.isFacedId;
              isDeviceHasBiometric = state.isDeviceHasBiometric;
              if (state.availableBiometrics.isEmpty) {
                enableBioMetricButton = true;
              } else {
                if (isFaceIdEnable) {
                  enableBioMetricButton = true;
                } else {
                  enableBioMetricButton = false;
                }
              }
            } else if(state is BiometricAuthState) {
              if(state.isAuthSuccess){
                PrefUtils.saveBool(PrefUtils.keyEnableBioMetric, true);
                PrefUtils.saveBool(PrefUtils.keyActiveBioMetric, true);
                if (widget.isFromSetting == false) {
                 context.goNamed(Routes.login.name, extra: <Profiles>[]);
                } else {
                  context.pop(true);
                }
              }
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Text(
                  getString(msgUseBiometricAuthentication),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  getString(msgUseBiometricWith),
                  maxLines: 8,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(
                  height: 40,
                ),
                if (availableBiometrics.isNotEmpty) ...{
                  Visibility(visible: isFacedId,child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Platform.isAndroid ? getString(faceId) : getString(fingerprintExcludeId),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      CustomSwitchButton(
                        value: isFaceIdEnable,
                        onChanged: (bool value) {
                          setState(() {
                            isFaceIdEnable = value;
                            if(isFaceIdEnable){
                              enableBioMetricButton = true;
                            } else {
                              enableBioMetricButton = false;
                            }
                          });
                        },
                      )
                    ],
                  ),),
                } else ...{
                  Text(
                    getString(msgUseBiometricNotRegistered),
                    style: Theme.of(context).textTheme.labelMedium,
                  )
                },
                const Spacer(),
                const SizedBox(height: 20,),
                AbsorbPointer(
                    absorbing: !enableBioMetricButton,
                    child: Align(
                        alignment: Alignment.center,
                        child: CustomElevatedButton(
                          onPressed: () {
                            if (availableBiometrics.isNotEmpty) {
                              context
                                  .read<BiometricCubit>()
                                  .registerWithBiometric();
                            } else {
                              // context.read<BiometricCubit>().getSettings();
                              if(Platform.isAndroid){
                                const OpenSettingsPlusAndroid().biometricEnroll();
                              } else {
                                const OpenSettingsPlusIOS().faceIDAndPasscode();
                              }
                            }
                          },
                          width: double.maxFinite,
                          text: availableBiometrics.isEmpty &&
                              isDeviceHasBiometric
                              ? getString(registerBiometric)
                              : getString(enableBiometric),
                          margin: EdgeInsets.symmetric(horizontal: 3.h),
                          buttonStyle: ElevatedButton.styleFrom(
                              backgroundColor: enableBioMetricButton
                                  ? Theme.of(context).highlightColor
                                  : Theme.of(context).disabledColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.h),
                              )),
                          buttonTextStyle: enableBioMetricButton
                              ? Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.white)
                              : Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).unselectedWidgetColor),

                        ))),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  child: Text(
                    getString(biometricSkipForNow),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: AppDimens.titleSmall,
                        color: setColorBasedOnTheme(
                          context: context,
                          lightColor: AppColors.secondaryLight,
                          darkColor: AppColors.secondaryLight5,
                        ),
                        fontWeight: FontWeight.w700),
                  ),
                  onPressed: () async {
                    PrefUtils.saveBool(PrefUtils.keyEnableBioMetric, false);
                    PrefUtils.saveBool(PrefUtils.keyActiveBioMetric, false);
                    if (widget.isFromSetting == false) {
                      context.goNamed(Routes.login.name, extra: <Profiles>[]);
                    } else {
                      context.pop(false);
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            );
          },
        ),
      ),
    ));
  }
}
