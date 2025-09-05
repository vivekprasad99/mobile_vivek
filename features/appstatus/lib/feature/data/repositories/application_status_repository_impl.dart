import 'package:appstatus/feature/data/datasources/application_status_datasource.dart';
import 'package:appstatus/feature/data/models/application_status_category_response.dart';
import 'package:appstatus/feature/data/models/application_status_request.dart';
import 'package:appstatus/feature/data/models/application_status_response.dart';
import 'package:appstatus/feature/domain/repositories/application_status_repository.dart';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';

class ApplicationStatusRepositoryImpl extends ApplicationStatusRepository {
  ApplicationStatusRepositoryImpl({required this.datasource});
  final ApplicationStatusDataSource datasource;

  @override
  Future<Either<Failure, ApplicationStatusResponse>> getApplicationStatus(ApplicationStatusRequest applicationStatusRequest) async{
    final result = await datasource.getApplicationStatus(applicationStatusRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }
  @override
  Future<Either<Failure, ApplicationStatusCategoryResponse>> getApplicationStatusCategory() async{
    final result = await datasource.getApplicationStatusCategory();
    return result.fold((left) => Left(left), (right) => Right(right));
  }

}
