import 'package:core/config/error/failure.dart';
import 'package:core/features/app_content/data/model/app_content_response.dart';
import 'package:core/features/app_content/domain/repositories/app_content_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../config/usecase/usecase.dart';

class AppContentUsecase extends UseCase<AppContentResponse, NoParams> {
  final AppContentRepository appContentRepository;

  AppContentUsecase({required this.appContentRepository});

  @override
  Future<Either<Failure, AppContentResponse>> call(params) async{
  return await appContentRepository.getTollFreeNum();
  }
}