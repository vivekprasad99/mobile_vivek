import 'dart:async';
import 'dart:io';
import 'package:auth/features/login_and_registration/presentation/cubit/auth_result_cubit.dart';
import 'package:common/features/home/presentation/cubit/home_cubit.dart';
import 'package:common/features/search/data/model/search_response.dart';
import 'package:common/features/startup/injection_container.dart';
import 'package:common/features/startup/presentation/cubit/app_launch_cubit.dart';
import 'package:common/features/startup/presentation/cubit/validate_device_cubit.dart';
import 'package:common/injection_container.dart';
import 'package:core/config/flavor/app_config.dart';
import 'package:core/config/flavor/feature_flag/feature_flag.dart';
import 'package:core/config/flavor/feature_flag/feature_flag_keys.dart';
import 'package:core/config/managers/firebase/analytics_manager.dart';
import 'package:core/config/managers/firebase/crashlytics_manager.dart';
import 'package:core/config/network/httpoverideglobal_ssl.dart';
import 'package:core/config/network/network_utils.dart';
import 'package:core/features/presentation/bloc/sticky_action_button/cubit/sticky_action_button_cubit.dart';
import 'package:core/features/presentation/bloc/theme/theme_bloc.dart';
import 'package:core/routes/app_route_cubit.dart';

import 'package:core/services/di/injection_container.dart';
import 'package:core/utils/encryption/aes_encryption_utils.dart';
import 'package:core/utils/encryption/preference_helper.dart';
import 'package:core/utils/helper/log.dart';
import 'package:core/utils/navigator_service.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:fintogo/config/feature_flag/feature_flag_sit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:locate_us/locate_us.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../features/main_app/presentation/mf_app.dart';

void main(){
  // Non-async exceptions
  FlutterError.onError = (errorDetails) {
    CrashlyticsManager.recordError(
      errorDetails.exception,
      errorDetails.stack!,
    );
    FlutterError.presentError(errorDetails);
  };
  // Async exceptions
  PlatformDispatcher.instance.onError = (error, stack) {
    FlutterError.reportError(FlutterErrorDetails(
      exception: error,
      stack: stack,
    ));
    return true;
  };
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    HttpOverrides.global = MyHttpOverrides();
    await dotenv.load(fileName: 'mobile-config/common/dev.env');
    AppConfig.create(
        appName: "MF-Sit",
        baseUrl: "https://api-dev.mmfsl.com",
        apiSuffix: "/oneapp-sit/api/",
        msSuffix: "/oneapp-sit/api/",
        postLoginTokenSuffix: "/oauth/oneApp-sit/",
        preLoginTokenUserName: preLoginTokenUserName,
        preLoginTokenPassword: preLoginTokenPassword,
        postLoginTokenUserName: postLoginTokenUserName,
        postLoginTokenPassword: postLoginTokenPassword,
        flavor: Flavor.sit,
        featureFlag: featureFlagSIT,
        botId: "x1713245039555",
        );
    await PreferencesHelper.setRSAPublicKey(rsaPublicKey);
    EncryptionUtilsAES.getInstance;
    await Hive.initFlutter();
    Hive.registerAdapter(SearchDataAdapter());
    Hive.registerAdapter(ExtraConversionAdapter());
    Hive.registerAdapter(LoansTabBarArgumentsAdapter());
    Hive.registerAdapter(ServicesNavigationRequestAdapter());
    await initCoreDI();
    await initCommon();
    await initMainAppDI();
    await PrefUtils.init();
    await AnalyticsManager.init();
    await CrashlyticsManager.init();
    LocateUsServices.init();
    if (isFeatureEnabled(featureName: featureEnableLogs)){
      await FlutterLogs.initLogs(
          logLevelsEnabled: [
            LogLevel.INFO,
            LogLevel.WARNING,
            LogLevel.ERROR,
            LogLevel.SEVERE
          ],
          timeStampFormat: TimeStampFormat.TIME_FORMAT_SIMPLE,
          directoryStructure: DirectoryStructure.SINGLE_FILE_FOR_DAY,
          logTypesEnabled: ["device", "network", "errors"],
          logFileExtension: LogFileExtension.TXT,
          logsWriteDirectoryName: "SuperApp",
          logsExportDirectoryName: "response/Exported",
          debugFileOperations: true,
          isDebuggable: true);
    }
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
            BlocProvider(
              create: (context) => di<ValidateDeviceCubit>(),
            ),
            BlocProvider(
              create: (context) => di<QuickActionCubit>(),
            ),
            BlocProvider(
              create: (context) => di<AppRouteCubit>(),
            ),
            BlocProvider(
              create: (context) => di<HomeCubit>(),
            ),
          ],
          child: MaterialApp(
            home: const MFApp(),
            navigatorKey: NavigatorService.navigatorKey,
          ),
        )));
  }, (error, stack) {
    log.e('', error: error, stackTrace: stack);
  });
}
