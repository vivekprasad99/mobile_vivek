import 'dart:async';
import 'package:common/features/startup/injection_container.dart';
import 'package:common/features/startup/presentation/cubit/app_launch_cubit.dart';
import 'package:core/config/flavor/app_config.dart';
import 'package:core/features/presentation/bloc/theme/theme_bloc.dart';

import 'package:core/services/di/injection_container.dart';
import 'package:core/utils/helper/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/feature_flag/feature_flag_prod.dart';

import 'features/main_app/presentation/mf_app.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    AppConfig.create(
        appName: "MF",
        baseUrl: "https://mfapp.com",
        flavor: Flavor.prod,
        featureFlag: featureFlagProd);
    await initCoreDI();
    await initMainAppDI();
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
          ],
          child: const MFApp(),
        )));
  }, (error, stack) {
    log.d('error - $stack');
  });
}
