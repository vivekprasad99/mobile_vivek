import 'package:common/features/privacy_policy/data/datasource/privacy_policy_datasource.dart';
import 'package:common/features/privacy_policy/domain/usecases/privacy_policy_usecases.dart';
import 'package:common/features/privacy_policy/presentation/cubit/privacy_policy_cubit.dart';
import 'package:core/services/di/injection_container.dart';

import 'data/repositories/privacy_policy_repository_impl.dart';
import 'domain/respositories/privacy_policy_repository.dart';

Future<void> initPrivacyPolicyDI() async {
  di.registerFactory(() => PrivacyPolicyDataSource(dioClient: di()));
  di.registerFactory<PrivacyPolicyRepository>(
      () => PrivacyPolicyRepositoryImpl(datasource: di()),);
  di.registerFactory(() => PrivacyPolicyUseCase(repository: di()));
  di.registerFactory(() => PrivacyPolicyCubit(privacyPolicyUseCase: di()));
}
