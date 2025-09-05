import 'package:appstatus/feature/data/models/application_status_request.dart';
import 'package:appstatus/feature/domain/usecases/application_status_usecase.dart';
import 'package:core/config/config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'application_status_state.dart';

class ApplicationStatusCubit extends Cubit<ApplicationStatusState> {
  final ApplicationStatusUseCase applicationStatusUseCase;
  ApplicationStatusCubit({required this.applicationStatusUseCase})
      : super(AppStatusInitial());

  getApplicationStatus(
      {required ApplicationStatusRequest applicationStatusRequest}) async {
    try {
      emit(LoadingState(isLoading: true));
      final result =
          await applicationStatusUseCase.call(applicationStatusRequest);
      emit(LoadingState(isLoading: false));
      result.fold((l) => emit(ApplicationStatusFailureState(error: l)),
          (r) => emit(ApplicationStatusSuccessState(response: r)));
    } catch (e) {
      emit(ApplicationStatusFailureState(error: NoDataFailure()));
    }
  }
  getApplicationStatusCategory() async {
    try {
      emit(LoadingState(isLoading: true));
      final result =
          await applicationStatusUseCase.callcategory();
      emit(LoadingState(isLoading: false));
      result.fold((l) => emit(ApplicationStatusFailureState(error: l)),
          (r) => emit(ApplicationStatusCategorySuccessState(response: r)));
    } catch (e) {
      emit(ApplicationStatusFailureState(error: NoDataFailure()));
    }
  }
}
