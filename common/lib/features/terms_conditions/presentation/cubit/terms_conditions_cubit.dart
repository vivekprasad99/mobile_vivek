import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/terms_conditions_request.dart';
import '../../domain/usecases/terms_conditions_usecases.dart';
import 'terms_conditions_state.dart';

class TermsConditionsCubit extends Cubit<TermsConditionsState> {
  TermsConditionsCubit({required this.termsConditionsUseCase})
      : super(TermsConditionsInitial());
  final TermsConditionsUseCase termsConditionsUseCase;

  void getTermsConditions(TermsConditionsRequest request) async {
    emit(LoadingState(isLoading: true));
    try {
      final result = await termsConditionsUseCase.call(request);
      emit(LoadingState(isLoading: false));
      result.fold((l) => emit(TermsConditionsFailureState(failure: l)),
          (r) => emit(TermsConditionsSuccessState(response: r)),);
    } catch (e) {
      emit(LoadingState(isLoading: false));
    }
  }
}
