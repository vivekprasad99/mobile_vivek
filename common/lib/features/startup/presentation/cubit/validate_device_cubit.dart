import 'package:common/features/startup/data/models/validate_device_request.dart';
import 'package:common/features/startup/domain/usecases/validate_device_usecase.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/flavor/feature_flag/feature_flag.dart';
import 'package:core/config/flavor/feature_flag/feature_flag_keys.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'validate_device_state.dart';

class ValidateDeviceCubit extends Cubit<ValidateDeviceState> {
  ValidateDeviceCubit({required this.validateDeviceUseCase})
      : super(ValidateDeviceInitState());
  final ValidateDeviceUseCase validateDeviceUseCase;

  validateDevice({required ValidateDeviceRequest validateDeviceRequest}) async {
    try {
      emit(LoadingDialogState(isValidateDeviceLoading: true));
      if (!isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await validateDeviceUseCase.call(validateDeviceRequest);
      emit(LoadingDialogState(isValidateDeviceLoading: false));
      result.fold((l) => emit(ValidateDeviceFailureState(error: l)),
          (r){
            PrefUtils.saveString(PrefUtils.keySelectedLanguage,r.profiles?.first.languageCode ?? "");
            PrefUtils.saveInt(PrefUtils.keyProfileCount,r.profiles?.length ?? 0);
            emit(ValidateDeviceSuccessState(response: r));
          });
    } catch (e) {
      emit(LoadingDialogState(isValidateDeviceLoading: false));
      emit(ValidateDeviceFailureState(error: NoDataFailure()));
    }
  }

  getAppLaunchConfig() async {
    try {
      final result = await validateDeviceUseCase.getAppLaunchConfig();
      result.fold((l) => emit(AppLaunchConfigFailureState(error: l)),
              (r) => emit(AppLaunchConfigSuccessState(response: r)),);
    } catch (e) {
      emit(AppLaunchConfigFailureState(error: NoDataFailure()));
    }
  }

  getPreLoginToken() async {
    try {
      emit(LoadingDialogState(isValidateDeviceLoading: true));
      final result = await validateDeviceUseCase.getPreLoginToken();
      emit(LoadingDialogState(isValidateDeviceLoading: false));
      result.fold((l) => emit(PreLoginTokenFailureState(error: l)),
              (r) => emit(PreLoginTokenSuccessState(response: r)),);
    } catch (e) {
      emit(PreLoginTokenFailureState(error: NoDataFailure()));
    }
  }
}
