
import 'package:appstatus/feature/data/models/application_status_category_response.dart';
import 'package:appstatus/feature/data/models/application_status_request.dart';
import 'package:appstatus/feature/data/models/application_status_response.dart';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class ApplicationStatusRepository {
  Future<Either<Failure, ApplicationStatusResponse>> getApplicationStatus(ApplicationStatusRequest applicationStatusRequest);
  Future<Either<Failure, ApplicationStatusCategoryResponse>> getApplicationStatusCategory();
}
