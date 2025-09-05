import 'package:common/features/privacy_policy/data/models/get_privacy_policy_response.dart';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import '../../domain/respositories/privacy_policy_repository.dart';
import '../datasource/privacy_policy_datasource.dart';
import '../models/get_privacy_policy_request.dart';

class PrivacyPolicyRepositoryImpl implements PrivacyPolicyRepository {
  PrivacyPolicyRepositoryImpl({required this.datasource});
  final PrivacyPolicyDataSource datasource;

  @override
  Future<Either<Failure, GetPrivacyPolicyResponse>> getPrivacyPolicy(
      GetPrivacyPolicyRequest getPrivacyPolicyRequest,) async {
    final result = await datasource.getPrivacyPolicy(getPrivacyPolicyRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }
}
