import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:core/config/flavor/feature_flag/feature_flag.dart';
import 'package:core/config/flavor/feature_flag/feature_flag_keys.dart';
import 'package:core/config/managers/device_manager.dart';
import 'package:core/config/managers/quick_action_manager.dart';
import 'package:core/config/network/connectivity/vpn_manager.dart';
import 'package:core/config/network/connectivity_manager.dart';
import 'package:core/config/network/dio_client.dart';
import 'package:core/config/network/dio_client_doc_upload.dart';
import 'package:core/features/app_content/data/datasources/app_content_datasource.dart';
import 'package:core/features/app_content/data/repositories/app_content_repository_impl.dart';
import 'package:core/features/app_content/domain/repositories/app_content_repository.dart';
import 'package:core/features/app_content/domain/usecases/app_content_usecase.dart';
import 'package:core/routes/app_route_cubit.dart';
import 'package:get_it/get_it.dart';
import '../../features/presentation/bloc/sticky_action_button/cubit/sticky_action_button_cubit.dart';
import '../../routes/app_route_state.dart';

GetIt di = GetIt.instance;

Future<void> initCoreDI() async {
  di.registerFactory(() => DioClient());
  di.registerSingleton<DioClientDocUpload>(DioClientDocUpload());
  di.registerFactory(() => Connectivity());
  di.registerFactory(() => ConnectivityManager());
  di.registerFactory(() => VPNCheckManager());
  di.registerFactory(() => isFeatureEnabled(featureName: featureBrowserstack)
      ? DeviceManager()
      : (DeviceManager()..enableSecureMode()));
  di.registerFactory(() => AppContentDataSource(dioClient: di()));
  di.registerFactory<AppContentRepository>(
      () => AppContentRepositoryImpl(datasource: di()));
  di.registerFactory(() => AppContentUsecase(appContentRepository: di()));
  di.registerFactory(() => QuickActionCubit(appContentUsecase: di()));
  di.registerFactory(() => QuickActionManager());
  di.registerFactory(() => AppRouteCubit(RouteInitState()));
}
