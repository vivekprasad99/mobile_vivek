import 'package:common/features/language_selection/data/models/app_label_request.dart';
import 'package:common/features/language_selection/data/models/app_labels_response.dart';
import 'package:common/features/language_selection/domain/repositories/select_language_repository.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class AppLabelsUseCase extends UseCase<AppLabelsResponse, AppLabelRequest> {
  final SelectLanguagesRepository repository;

  AppLabelsUseCase({required this.repository});

  @override
  Future<Either<Failure, AppLabelsResponse>> call(
      AppLabelRequest params,) async {
    return await repository.getAppLabels(params);
  }
}
