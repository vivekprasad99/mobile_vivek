import 'package:common/features/language_selection/data/models/app_label_request.dart';
import 'package:common/features/language_selection/data/models/app_labels_response.dart';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import '../../data/models/language_response.dart';
import '../../data/models/update_device_lang_request.dart';
import '../../data/models/update_device_lang_response.dart';

abstract class SelectLanguagesRepository {
  Future<Either<Failure, SelectLanguageResponse>> getAppLanguages();

  Future<Either<Failure, AppLabelsResponse>> getAppLabels(
      AppLabelRequest appLabelRequest,);

  Future<Either<Failure, UpdateDeviceLangResponse>> updateDeviceLanguage(
      UpdateUserLangRequest updateDeviceLangRequest);
}
