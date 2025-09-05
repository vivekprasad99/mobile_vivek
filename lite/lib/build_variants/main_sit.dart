import 'dart:async';
import 'package:auth/features/login_and_registration/presentation/cubit/auth_result_cubit.dart';
import 'package:common/features/startup/injection_container.dart';
import 'package:common/features/startup/presentation/cubit/app_launch_cubit.dart';
import 'package:common/injection_container.dart';
import 'package:core/config/flavor/app_config.dart';
import 'package:core/features/presentation/bloc/theme/theme_bloc.dart';

import 'package:core/services/di/injection_container.dart';
import 'package:core/utils/helper/log.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config/feature_flag/feature_flag_sit.dart';
import '../features/main_app/presentation/mf_app.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    AppConfig.create(
        appName: "MF-Sit",
        baseUrl: "https://mfapp-sit.com",
        flavor: Flavor.sit,
        featureFlag: featureFlagSIT);
    await initCoreDI();
    await initCommon();
    await initMainAppDI();
    await PrefUtils.init();
    return SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    ).then((_) => runApp(MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => di<AppLaunchCubit>(),
            ),
            BlocProvider(
              create: (context) => di<ThemeBloc>(),
            ),
            BlocProvider(
              create: (context) => di<AuthResultCubit>(),
            ),
          ],
          child: const MaterialApp(home: MFApp()),
        )));
  }, (error, stack) {
    log.d('error - $stack');
  });
}
