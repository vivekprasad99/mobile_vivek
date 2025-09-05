import 'package:common/features/language_selection/data/models/app_labels_response.dart';
import 'package:common/features/startup/data/models/validate_device_response.dart';
import 'package:core/config/error/failure.dart';

import '../../data/models/language_response.dart';
import '../../data/models/update_device_lang_response.dart';

abstract class SelectLanguageState {}

class SelectLanguageInitial extends SelectLanguageState {}

class AppLabelLoadingState extends SelectLanguageState {
  final bool isloading;
  AppLabelLoadingState({required this.isloading});

  List<Object?> get props => [isloading];
}

class SelectLanguageSuccess extends SelectLanguageState {
  final SelectLanguageResponse response;

  SelectLanguageSuccess({required this.response});
}

class SelectLanguageFailure extends SelectLanguageState {
  final Failure error;

  SelectLanguageFailure({required this.error});
}

class AppLabelSuccess extends SelectLanguageState {
  final AppLabelsResponse response;
  final List<Profiles>? profiles;

  AppLabelSuccess({required this.response,this.profiles});

  List<Object?> get props => [response,profiles];
}

class AppLabelFailure extends SelectLanguageState {
  final Failure error;

  AppLabelFailure({required this.error});

  List<Object?> get props => [error];
}

class SelectLanguageIndex extends SelectLanguageState {
  final Language languages;

  SelectLanguageIndex({required this.languages});

  List<Object?> get props => [languages];
}

class UpdateDeviceLangSuccess extends SelectLanguageState {
  final UpdateDeviceLangResponse response;

  UpdateDeviceLangSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class UpdateDeviceLangFailure extends SelectLanguageState {
  final Failure error;

  UpdateDeviceLangFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
