import 'package:common/features/privacy_policy/data/models/get_privacy_policy_request.dart';
import 'package:common/features/privacy_policy/data/models/get_privacy_policy_response.dart';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class PrivacyPolicyRepository {
  Future<Either<Failure, GetPrivacyPolicyResponse>> getPrivacyPolicy(
      GetPrivacyPolicyRequest getPrivacyPolicyRequest,);
}
