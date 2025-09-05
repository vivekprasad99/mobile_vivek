import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import '../../data/models/terms_conditions_request.dart';
import '../../data/models/terms_conditions_response.dart';

abstract class TermsConditionsRepository {
  Future<Either<Failure, TermsConditionsResponse>> getTermsConditions(
      TermsConditionsRequest request,);
}
