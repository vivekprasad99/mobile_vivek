import 'package:common/features/home/data/models/update_theme_request.dart';
import 'package:common/features/home/domain/usecases/update_theme_usecase.dart';
import 'package:common/features/home/presentation/cubit/home_state.dart';
import 'package:core/config/config.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.updateThemeUseCase}) : super(HomeInitial());
  final UpdateThemeUseCase updateThemeUseCase;

  updateThemeDetail(UpdateThemeRequest updateThemeRequest) async {
    try {
      emit(LoadingState(isLoading: true));
      final result = await updateThemeUseCase.call(updateThemeRequest);
      emit(LoadingState(isLoading: false));
      result.fold((l) => emit(UpdateThemeFailure(error: l)),
          (r) => emit(UpdateThemeSuccess(response: r)),);
    } catch (e) {
      emit(LoadingState(isLoading: false));
      emit(UpdateThemeFailure(error: NoDataFailure()));
    }
  }

  void handleItemClick(String item) {
    emit(UpdateSelectedTab(selectedItem: item));
  }

  void clearSelectedItem(String item) {
    emit(UpdateSelectedTab(selectedItem: item));
  }

  void resetSelectedTab() {
    emit(UpdateSelectedTab(selectedItem: ""));
  }


  logOut() async {
    try {
      emit(LoadingState(isLoading: true));
      final result = await updateThemeUseCase
          .logout(PrefUtils.getString(PrefUtils.keyToken, ""));
      emit(LoadingState(isLoading: false));
      result.fold((l) => emit(LogoutResFailureState(error: l)), (r) {
        removeLoginData();
        emit(LogoutResSuccessState(resp: r));
      });
    } catch (e) {
      emit(LoadingState(isLoading: false));
      emit(LogoutResFailureState(error: NoDataFailure()));
    }
  }
}
