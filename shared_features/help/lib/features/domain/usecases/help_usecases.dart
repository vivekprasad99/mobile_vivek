import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import '../../data/models/help_response.dart';
import '../../data/models/help_request.dart';
import '../respositories/help_repository.dart';

class HelpUseCase
    extends UseCase<HelpResponse, HelpRequest> {
  final HelpRepository repository;
  HelpUseCase({required this.repository});

  @override
  Future<Either<Failure, HelpResponse>> call(
      HelpRequest params) async {
    return await repository.getHelpData(params);
  }
}
