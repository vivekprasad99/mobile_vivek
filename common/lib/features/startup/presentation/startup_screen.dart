import 'dart:io';

import 'package:auth/config/routes/route.dart' as auth;
import 'package:common/config/routes/route.dart' as common;
import 'package:common/features/language_selection/data/models/app_label_request.dart';
import 'package:common/features/language_selection/presentation/cubit/select_language_cubit.dart';
import 'package:common/features/language_selection/presentation/cubit/select_language_state.dart';
import 'package:common/features/startup/data/models/applaunch_config_response.dart';
import 'package:common/features/startup/data/models/validate_device_request.dart';
import 'package:common/features/startup/data/models/validate_device_response.dart';
import 'package:common/features/startup/presentation/cubit/validate_device_cubit.dart';
import 'package:common/features/startup/presentation/cubit/validate_device_state.dart';
import 'package:common/features/startup/presentation/widgets/splash.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/managers/device_manager.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_number/mobile_number.dart';

import '../../../helper/constant_data.dart';
import 'cubit/app_launch_cubit.dart';
import 'network_down_screen.dart';

class AppLaunchScreen extends StatefulWidget {
  const AppLaunchScreen({super.key});

  @override
  AppLaunchScreenState createState() => AppLaunchScreenState();
}

class AppLaunchScreenState extends State<AppLaunchScreen> {
  BuildContext? dialogContext;
  @override
  void initState() {
    super.initState();
    PrefUtils.removeData(PrefUtils.keyAuthNavFlow);
  }

  void checkPermissionStatus(BuildContext mContext) async {
    if (Platform.isAndroid && !await MobileNumber.hasPhonePermission) {
      await MobileNumber.requestPhonePermission;
    } else {
      if(context.mounted) {
        BlocProvider.of<AppLaunchCubit>(mContext).checkAppHealth();
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checkPermissionStatus(context);
    MobileNumber.listenPhonePermission((isPermissionGranted) {
      if (mounted) {
        BlocProvider.of<AppLaunchCubit>(context).checkAppHealth();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppLaunchCubit, AppLaunchState>(
            listener: (BuildContext context, AppLaunchState state) {
          if (state == AppLaunchState.rootJailBreakState) {
            displayAlert(context, ConstantData.rootedMsg);
          } else if (state == AppLaunchState.vpnConnectedState) {
            displayAlert(context, ConstantData.vpnMsg);
          } else if (state == AppLaunchState.appClonedState) {
            displayAlert(context, ConstantData.dualAppMsg);
          } else if (state == AppLaunchState.appLaunchSuccessState) {
            if(isInternetAvailable()) {
              BlocProvider.of<ValidateDeviceCubit>(context).getPreLoginToken();
            }
            // BlocProvider.of<ValidateDeviceCubit>(context).getAppLaunchConfig();
          }
        },),
        BlocListener<SelectLanguageCubit, SelectLanguageState>(
            listener: (context, state) {
                if(state is AppLabelSuccess){
                  context.goNamed(
                      auth.Routes.login.name, extra: state.profiles,);
                } else if(state is AppLabelFailure){
                  displayAlert(context, getString(lblLoginErrorGeneric));
                }
            },
            ),
        BlocListener<ValidateDeviceCubit, ValidateDeviceState>(
            listener: (context, state) {
          if (state is ValidateDeviceSuccessState) {
            ValidateDeviceResponse response = state.response;
            if (response.code == AppConst.codeSuccess) {
              if (response.deviceExist ?? false) {
                if (response.profiles?.isNotEmpty == true &&
                    response.profiles![0].mpinExists == false) {
                  setSuperAppId(response.profiles![0].superAppId ?? "");
                  context.goNamed(auth.Routes.mpin.name, extra: Profiles());
                } else {
                    if (getSuperAppId().isNotEmpty) {
                      for (Profiles e in response.profiles!) {
                        if (getSuperAppId() == e.superAppId) {
                          setSelectedLanguage(e.languageCode);
                          AppLabelRequest appLabelRequest =
                              AppLabelRequest(langCode: e.languageCode);
                          context
                              .read<SelectLanguageCubit>()
                              .getAppLabels(appLabelRequest,response.profiles);
                          break;
                        }
                      }
                    } else {
                      AppLabelRequest appLabelRequest = AppLabelRequest(
                          langCode: response.profiles![0].languageCode);
                      context
                          .read<SelectLanguageCubit>()
                          .getAppLabels(appLabelRequest,response.profiles);
                    }
                }
              } else {
                context.goNamed(common.Routes.languageSelection.name);
              }
            } else {
              context.goNamed(common.Routes.languageSelection.name);
            }
          } else if (state is ValidateDeviceFailureState) {
            if (state.error is ServerFailure) {
              displayAlert(context, (state.error as ServerFailure).message.toString());
            } else {
              displayAlert(context, state.error.toString());
            }
          } else if (state is AppLaunchConfigSuccessState) {
            AppLaunchConfigResponse response = state.response;
            if (response.code == AppConst.codeSuccess) {
              PrefUtils.saveInt(PrefUtils.keyCreateMpinMaxAttempt, response.createMpinMaxAttempt??AppConst.createMpinMaxAttempt);
              PrefUtils.saveInt(PrefUtils.keyPanLanMaxAttempt, response.createMpinMaxAttempt??AppConst.maxPanLanAttempts);
              PrefUtils.saveString(PrefUtils.paymentTat, response.paymentTat??AppConst.paymentTat);
              DeviceManager().getAppVersion().then((appVersion) => {
                if (compareVersions(appVersion, response.androidBuildVersion!) < 0) {
                     displayForceUpdateAlert(context,getString(lblUpdateYourApp), showLeftButton: response.androidForceUpdateFlag==false, onTap: () => {
                       BlocProvider.of<ValidateDeviceCubit>(context).validateDevice(
                           validateDeviceRequest: ValidateDeviceRequest(
                               deviceId: getDeviceId(), source: AppConst.source,),),
                     }, ),
                } else {
                  BlocProvider.of<ValidateDeviceCubit>(context).validateDevice(
                                validateDeviceRequest: ValidateDeviceRequest(
                                    deviceId: getDeviceId(), source: AppConst.source,),),
                      },
                  },);
            } else {
              displayAlert(context, response.message??"");
            }
          } else  if (state is AppLaunchConfigFailureState) {
            if (state.error is ServerFailure) {
              if((state.error as ServerFailure).statusCode=="401" || (state.error as ServerFailure).statusCode=="500"){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    dialogContext = context;
                    return const NetworkDownScreen();
                  },
                );
              } else {
                displayAlert(
                    context, (state.error as ServerFailure).message.toString(),);
              }
            } else {
              displayAlert(context, state.error.toString());
            }
          } else if (state is PreLoginTokenSuccessState) {
            PrefUtils.saveString(
                PrefUtils.keyToken, state.response.accessToken??"",);
            BlocProvider.of<ValidateDeviceCubit>(context).getAppLaunchConfig();
          } else  if (state is PreLoginTokenFailureState) {
            if (state.error is ServerFailure) {
              if((state.error as ServerFailure).statusCode=="401" || (state.error as ServerFailure).statusCode=="500"){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    dialogContext = context;
                    return const NetworkDownScreen();
                  },
                );
              } else {
                displayAlert(
                    context, (state.error as ServerFailure).message.toString(),);
              }
            } else {
              displayAlert(context, state.error.toString());
            }
          }
          // else {
          //   context.goNamed(common.Routes.languageSelection.name);
          // }
        },),
      ],
      child: BlocBuilder<AppLaunchCubit, AppLaunchState>(
          builder: (BuildContext context, AppLaunchState state) {
        return const Scaffold(
          body: Center(
              child: Stack(alignment: Alignment.center, children: [Splash()]),),
        );
      },),
    );
  }
}
