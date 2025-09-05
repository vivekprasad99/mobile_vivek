import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:help/features/domain/respositories/help_repository.dart';
import '../datasource/help_datasource.dart';
import '../models/help_response.dart';
import '../models/help_request.dart';

class HelpRepositoryImpl implements HelpRepository {
  HelpRepositoryImpl({required this.datasource});
  final HelpDataSource datasource;

  @override
  Future<Either<Failure, HelpResponse>> getHelpData(
      HelpRequest request) async {
    final result = await datasource.getHelpData(request);
    return result.fold((left) => Left(left), (right) => Right(right));
  }
}
