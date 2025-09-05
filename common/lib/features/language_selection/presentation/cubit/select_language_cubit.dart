import 'package:auth/features/mobile_otp/presentation/cubit/phone_validate_state.dart';
import 'package:common/features/language_selection/data/models/app_label_request.dart';
import 'package:common/features/language_selection/data/models/language_response.dart';
import 'package:common/features/language_selection/domain/usecases/app_labels_usecase.dart';
import 'package:common/features/startup/data/models/validate_device_response.dart';
import 'package:core/config/config.dart';
import 'package:core/config/string_resource/config.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/update_device_lang_request.dart';
import '../../domain/usecases/select_language_usecase.dart';
import 'select_language_state.dart';

class SelectLanguageCubit extends Cubit<SelectLanguageState> {
  SelectLanguageCubit(
      {required this.appLanguagesUseCase, required this.appLabelsUseCase,})
      : super(SelectLanguageInitial());
  final SelectLanguageUseCase appLanguagesUseCase;
  final AppLabelsUseCase appLabelsUseCase;

  getAppLanguages() async {
    final result = await appLanguagesUseCase.call(NoParams());
    result.fold((l) => emit(SelectLanguageFailure(error: l)), (r) {
      r.data?.languages?.forEach((element) {
        if (element.langCode == getSelectedLanguage()) {
          element.isSelected = true;
        }
      });
      emit(SelectLanguageSuccess(response: r));
    });
  }

  getAppLabels(AppLabelRequest appLabelRequest,[List<Profiles>? profiles]) async {
    emit(AppLabelLoadingState(isloading: true));
    try {
      final result = await appLabelsUseCase.call(appLabelRequest);
      result.fold((l) {
        emit(AppLabelFailure(error: l));
        emit(AppLabelLoadingState(isloading: false));
      }, (r) {
        emit(AppLabelLoadingState(isloading: false));
        if (r.labels!.isNotEmpty) lang = r.labels!;
        emit(AppLabelSuccess(response: r,profiles: profiles));
      });
    } catch (e) {
      emit(AppLabelLoadingState(isloading: false));
      emit(AppLabelFailure(error: NoDataFailure()));
    }
  }

  void getSelectedIndex(Language selectedLanguage) {
    emit(SelectLanguageIndex(languages: selectedLanguage));
  }

  updateUserLanguage(UpdateUserLangRequest updateDeviceLangRequest) async {
    emit(AppLabelLoadingState(isloading: true));
    try {
      final result =
      await appLanguagesUseCase.updateDeviceLanguage(updateDeviceLangRequest);
      emit(AppLabelLoadingState(isloading: false));
      result.fold((l) => emit(UpdateDeviceLangFailure(error: l)),
              (r) => emit(UpdateDeviceLangSuccess(response: r)));
    } catch (e) {
      emit(AppLabelLoadingState(isloading: false));
      emit(UpdateDeviceLangFailure(error: NoDataFailure()));
    }
  }
}
