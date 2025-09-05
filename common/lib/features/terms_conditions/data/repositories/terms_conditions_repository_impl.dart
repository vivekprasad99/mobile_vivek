import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import '../../domain/respositories/terms_conditions_repository.dart';
import '../datasource/terms_conditions_datasource.dart';
import '../models/terms_conditions_response.dart';
import '../models/terms_conditions_request.dart';

class TermsConditionsRepositoryImpl implements TermsConditionsRepository {
  TermsConditionsRepositoryImpl({required this.datasource});
  final TermsConditionsDataSource datasource;

  @override
  Future<Either<Failure, TermsConditionsResponse>> getTermsConditions(
      TermsConditionsRequest request,) async {
    final result = await datasource.getTermsConditions(request);
    return result.fold((left) => Left(left), (right) => Right(right));
  }
}
