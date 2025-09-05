import 'package:common/config/routes/app_route.dart';
import 'package:common/features/startup/presentation/cubit/app_launch_cubit.dart';
import 'package:common/helper/constant_data.dart';
import 'package:core/config/resources/app_dimens.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:core/config/resources/app_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';

class MFApp extends StatelessWidget {
  const MFApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (__) => di<AppLaunchCubit>())],
      child: OKToast(
        child: ScreenUtilInit(
          //TODO add standards as per the VDs
          designSize:
              const Size(AppDimens.standardWidth, AppDimens.standardWidth),
          minTextAdapt: true,
          splitScreenMode: false,
          builder: (context, __) {
            AppRoute.setStream(context);
            return BlocConsumer<AppLaunchCubit, AppLaunchState>(
              listener: (context, state) {},
              builder: (context, state) {
                return BlocBuilder<AppLaunchCubit, AppLaunchState>(
                    builder: (context, state) {
                  String selectedLocale = 'en';

                  return MaterialApp.router(
                    routerConfig: AppRoute.router,
                    locale: Locale(selectedLocale),
                    debugShowCheckedModeBanner: false,
                    title: ConstantData.get.appName,
                    theme: themeLight(context),
                    darkTheme: themeDark(context),
                    themeMode: ThemeMode.system,
                    builder: (context, child) {
                      final MediaQueryData data = MediaQuery.of(context);
                      return MediaQuery(
                          data: data.copyWith(
                              textScaler: TextScaler.noScaling,
                              alwaysUse24HourFormat: true),
                          child: child!);
                    },
                  );
                });
              },
            );
          },
        ),
      ),
    );
  }
}
