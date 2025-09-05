import 'package:common/features/privacy_policy/data/models/get_privacy_policy_request.dart';
import 'package:common/features/privacy_policy/data/models/get_privacy_policy_response.dart';
import 'package:common/features/privacy_policy/domain/respositories/privacy_policy_repository.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class PrivacyPolicyUseCase
    extends UseCase<GetPrivacyPolicyResponse, GetPrivacyPolicyRequest> {
  final PrivacyPolicyRepository repository;
  PrivacyPolicyUseCase({required this.repository});

  @override
  Future<Either<Failure, GetPrivacyPolicyResponse>> call(
      GetPrivacyPolicyRequest params,) async {
    return await repository.getPrivacyPolicy(params);
  }
}
