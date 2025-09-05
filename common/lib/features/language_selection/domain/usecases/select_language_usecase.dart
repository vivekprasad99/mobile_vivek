import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import '../../data/models/language_response.dart';
import '../../data/models/update_device_lang_request.dart';
import '../../data/models/update_device_lang_response.dart';
import '../repositories/select_language_repository.dart';

class SelectLanguageUseCase extends UseCase<SelectLanguageResponse, NoParams> {
  final SelectLanguagesRepository repository;

  SelectLanguageUseCase({required this.repository});

  @override
  Future<Either<Failure, SelectLanguageResponse>> call(NoParams params) async {
    return await repository.getAppLanguages();
  }

  Future<Either<Failure, UpdateDeviceLangResponse>> updateDeviceLanguage(UpdateUserLangRequest request) async {
    return await repository.updateDeviceLanguage(request);
  }
}
