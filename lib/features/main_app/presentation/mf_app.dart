import 'dart:io';

import 'package:auth/features/login_and_registration/presentation/cubit/auth_result_cubit.dart';
import 'package:common/config/routes/app_route.dart';
import 'package:common/config/routes/route.dart';
import 'package:common/features/home/presentation/cubit/home_cubit.dart';
import 'package:common/features/home/presentation/cubit/home_state.dart';
import 'package:common/features/startup/data/models/validate_device_response.dart';
import 'package:common/features/startup/presentation/cubit/app_launch_cubit.dart';
import 'package:common/features/startup/presentation/cubit/validate_device_cubit.dart';
import 'package:common/features/startup/presentation/cubit/validate_device_state.dart';
import 'package:common/helper/constant_data.dart';
import 'package:core/config/widgets/mf_custom_dialog.dart';
import 'package:core/config/config.dart';
import 'package:core/config/flavor/app_config.dart';
import 'package:core/config/managers/firebase/analytics_manager.dart';
import 'package:core/config/managers/firebase/firebase_notification_message.dart';
import 'package:core/config/managers/firebase/local_notification.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/routes/app_route_cubit.dart';
import 'package:core/routes/app_route_state.dart';
import 'package:core/config/managers/device_manager.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/features/presentation/bloc/theme/theme_bloc.dart';
import 'package:core/utils/utils.dart';
import 'package:fintogo/config/widgets/internet_connectivity_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MFApp extends StatefulWidget {
  const MFApp({super.key});

  @override
  State<MFApp> createState() => _MFAppState();
}

class _MFAppState extends State<MFApp> {
  BuildContext? dialogContext;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late bool isLoggedOut;
  static const _iosMethodChannel =
      MethodChannel('com.example.mfsl/sfmcNotificationSwift');
  @override
  void initState() {
    isLoggedOut = false;
    setDataForGoogleAnalytics();
    context.read<AppLaunchCubit>().checkInternetContectivity();
    notificationNavigationRedirection();
    super.initState();
  }

  Future<void> setDataForGoogleAnalytics() async {
    final version = await DeviceManager().getAppVersion();
    await AnalyticsManager.setDefaultEventParameters({
      'version': '${AppConfig.shared.appName} $version',
    });
    // FirebaseCrashlytics.instance.setUserIdentifier("iamabhishek");
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        context.read<AppLaunchCubit>().appActive();
      },
      child: Sizer(builder: (context, orientation, deviceType) {
        return Scaffold(
            body: BlocConsumer<AppLaunchCubit, AppLaunchState>(
                builder: (context, state) {
          return OKToast(
            child: ScreenUtilInit(
              //TODO add standards as per the VDs
              designSize: const Size(
                  AppDimens.standardWidth, AppDimens.standardWidth),
              minTextAdapt: true,
              splitScreenMode: false,
              builder: (context, __) {
                AppRoute.setStream(context);
                return BlocBuilder<ThemeBloc, ThemeData>(
                    builder: (context, state) {
                  String selectedLocale = 'en';
                  return MultiBlocListener(
                    listeners: [
                      BlocListener<HomeCubit, HomeState>(
                        listener: (context, state) {
                          if (state is LogoutResSuccessState) {
                            isLoggedOut = true;
                            BlocProvider.of<ValidateDeviceCubit>(context)
                                .getPreLoginToken();
                          }
                        },
                      ),
                      BlocListener<ValidateDeviceCubit, ValidateDeviceState>(
                        listenWhen: (_, __) => isLoggedOut,
                        listener: (context, state) {
                          if (state is PreLoginTokenSuccessState) {
                            PrefUtils.saveString(PrefUtils.keyToken,
                                state.response.accessToken ?? "");
                            context
                                .read<AuthResultCubit>()
                                .setResult(success: false);
                            while(Navigator.of(context, rootNavigator: true).canPop()){
                              Navigator.of(context, rootNavigator: true).pop();
                            }
                            AppRoute.router.goNamed(Routes.login.name,
                                extra: <Profiles>[]);
                            Future.delayed(Duration.zero, () {
                              showMfCustomDialog(
                                context,
                                msg: getString(msgInactivityLogout),
                                buttonTitle: getString(lblLoginOk),
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                              );
                            });
                          } else if (state is PreLoginTokenFailureState) {
                            displayAlert(
                                context, getFailureMessage(state.error));
                          } else if (state is LoadingDialogState) {
                            if (state.isValidateDeviceLoading) {
                              showLoaderDialog(context, getString(lblLoading));
                            } else {
                              Navigator.of(context, rootNavigator: true).pop();
                            }
                          }
                        },
                      ),
                      BlocListener<AuthResultCubit, AuthResultState>(
                        listener: (context, state) {
                          AppRoute.router.refresh();
                        },
                      ),
                      BlocListener<AppRouteCubit, AppRouteState>(
                        listener: (context, state) {
                          AppRoute.router.refresh();
                        },
                      )
                    ],
                    child: MaterialApp.router(
                      routerConfig: AppRoute.router,
                      locale: Locale(selectedLocale),
                      debugShowCheckedModeBanner: false,
                      title: ConstantData.get.appName,
                      theme: state == ThemeData.dark()
                          ? themeDark(context)
                          : themeLight(context),
                      builder: (context, child) {
                        final MediaQueryData data = MediaQuery.of(context);
                        return MediaQuery(
                          data: data.copyWith(
                              textScaler: TextScaler.noScaling,
                              alwaysUse24HourFormat: true),
                          child: child!,
                        );
                      },
                    ),
                  );
                });
              },
            ),
          );
        }, listener: (context, state) {
          if (state == AppLaunchState.internetOffState) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                dialogContext = context;
                return const InternetConnectivityScreen();
              },
            );
          } else if (state == AppLaunchState.internetOnState) {
            if (dialogContext != null) {
              Navigator.of(dialogContext!).pop();
            }
          } else if(state == AppLaunchState.inactive){
            context.read<HomeCubit>().logOut();
          }
        }));
      }),
    );
  }
  dynamic notificationResultData;
  void notificationNavigationRedirection() async {

    if (Platform.isIOS) {
      _iosMethodChannel.setMethodCallHandler((handler) async {
        if (handler.method == 'getIOSsfmcNotification') {
          // Do your logic here.
          final dynamic pushData = handler.arguments;
          debugPrint('APNS Notification received: $pushData');
          notificationResultData = pushData;
          //add navigation
        } else {
          setState(() {
            notificationResultData =
                'Unknown method from MethodChannel: ${handler.method}';
          });
        }
      });
    } else {
      var initialNotification = await flutterLocalNotificationsPlugin
          .getNotificationAppLaunchDetails();
      debugPrint(initialNotification?.didNotificationLaunchApp.toString());
      if (initialNotification?.didNotificationLaunchApp == true) {
        //add navigation
      }
      var whenappclosednotificationmessage =
          await handleMessageWhenAppisclosed();
      if (whenappclosednotificationmessage != null) {
        debugPrint(whenappclosednotificationmessage.data.toString());
        //add navigation
      }
      LocalNotificationServices.onClickNotification.stream.listen((event) {
        debugPrint(event);
        //add navigation
      });
    }
  }
}
