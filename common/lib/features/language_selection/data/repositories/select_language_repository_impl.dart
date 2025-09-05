import 'package:common/features/language_selection/data/models/app_label_request.dart';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../../domain/repositories/select_language_repository.dart';
import '../datasources/select_language_datasource.dart';
import '../models/app_labels_response.dart';
import '../models/language_response.dart';
import '../models/update_device_lang_request.dart';
import '../models/update_device_lang_response.dart';

class SelectLanguageRepositoryImpl implements SelectLanguagesRepository {
  SelectLanguageRepositoryImpl({required this.datasource});

  final SelectLanguageDataSource datasource;

  @override
  Future<Either<Failure, SelectLanguageResponse>> getAppLanguages() async {
    final result = await datasource.getAppLanguages();
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, AppLabelsResponse>> getAppLabels(
      AppLabelRequest appLabelRequest,) async {
    final result = await datasource.getAppLabels(appLabelRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, UpdateDeviceLangResponse>> updateDeviceLanguage(UpdateUserLangRequest updateDeviceLangRequest) async {
    final result = await datasource.updateDeviceLanguage(updateDeviceLangRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }
}
