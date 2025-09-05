import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthResultState { init, success, failure }

class AuthResultCubit extends Cubit<AuthResultState> {
  AuthResultCubit(super.initialState);

  setResult({required bool success}) {
    success ? emit(AuthResultState.success) : emit(AuthResultState.failure);
  }

  reset() {
    emit(AuthResultState.init);
  }
}
