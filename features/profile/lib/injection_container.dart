import 'package:core/services/di/injection_container.dart';
import 'package:profile/data/data_sources/profile_data_source.dart';
import 'package:profile/data/repositories/profile_repository_impl.dart';
import 'package:profile/domain/repositories/profile_repository.dart';
import 'package:profile/domain/usecases/profile_usecases.dart';

import 'package:profile/presentation/cubit/profile_cubit.dart';

Future<void> initMyProfileDi() async {
  di.registerFactory(() => ProfileCubit(usecase: di()));

  di.registerFactory(
      () => ProfileDataSource(dioClient: di(), dioClientUnc: di()));
  di.registerFactory<ProfileRepository>(
      () => ProfileRepositoryImpl(profileDataSource: di()));
  di.registerFactory(() => ProfileUseCase(profileRepository: di()));
}
