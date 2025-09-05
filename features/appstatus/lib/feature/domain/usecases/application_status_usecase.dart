
import 'package:appstatus/feature/data/models/application_status_category_response.dart';
import 'package:appstatus/feature/data/models/application_status_request.dart';
import 'package:appstatus/feature/data/models/application_status_response.dart';
import 'package:appstatus/feature/domain/repositories/application_status_repository.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';


class ApplicationStatusUseCase extends UseCase<ApplicationStatusResponse, ApplicationStatusRequest> {
  final ApplicationStatusRepository applicationStatusRepository;
  ApplicationStatusUseCase({required this.applicationStatusRepository});

  @override
  Future<Either<Failure, ApplicationStatusResponse>> call(ApplicationStatusRequest params) async{
    return await applicationStatusRepository.getApplicationStatus(params);
  }
  Future<Either<Failure, ApplicationStatusCategoryResponse>> callcategory() async{
    return await applicationStatusRepository.getApplicationStatusCategory();
  }
}
