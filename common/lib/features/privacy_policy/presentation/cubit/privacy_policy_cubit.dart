import 'package:common/features/privacy_policy/data/models/get_privacy_policy_request.dart';
import 'package:common/features/privacy_policy/domain/usecases/privacy_policy_usecases.dart';
import 'package:common/features/privacy_policy/presentation/cubit/privacy_policy_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrivacyPolicyCubit extends Cubit<PrivacyPolicyState> {
  PrivacyPolicyCubit({required this.privacyPolicyUseCase})
      : super(PrivacyPolicyInitial());
  final PrivacyPolicyUseCase privacyPolicyUseCase;

  void getPrivacyPolicy(GetPrivacyPolicyRequest request) async {
    emit(LoadingState(isLoading: true));
    try {
      final result = await privacyPolicyUseCase.call(request);
      emit(LoadingState(isLoading: false));
      result.fold((l) => emit(PrivacyPolicyFailureState(failure: l)),
          (r) => emit(PrivacyPolicySuccessState(response: r)),);
    } catch (e) {
      emit(LoadingState(isLoading: false));
    }
  }
}
