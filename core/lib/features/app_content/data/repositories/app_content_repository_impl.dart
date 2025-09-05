import 'package:core/config/error/failure.dart';
import 'package:core/features/app_content/data/datasources/app_content_datasource.dart';
import 'package:core/features/app_content/data/model/app_content_response.dart';
import 'package:core/features/app_content/domain/repositories/app_content_repository.dart';
import 'package:dartz/dartz.dart';

class AppContentRepositoryImpl implements AppContentRepository {
  final AppContentDataSource datasource;
  AppContentRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<Either<Failure, AppContentResponse>> getTollFreeNum() async {
    final result = await datasource.getTollFreeNum();
    return result.fold((left) => Left(left), (right) => Right(right));
  }
}
