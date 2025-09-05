import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import '../../data/models/terms_conditions_response.dart';
import '../../data/models/terms_conditions_request.dart';
import '../respositories/terms_conditions_repository.dart';

class TermsConditionsUseCase
    extends UseCase<TermsConditionsResponse, TermsConditionsRequest> {
  final TermsConditionsRepository repository;
  TermsConditionsUseCase({required this.repository});

  @override
  Future<Either<Failure, TermsConditionsResponse>> call(
      TermsConditionsRequest params,) async {
    return await repository.getTermsConditions(params);
  }
}
