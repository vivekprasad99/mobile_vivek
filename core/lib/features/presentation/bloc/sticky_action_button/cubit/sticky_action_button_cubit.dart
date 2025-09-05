import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:core/features/app_content/domain/usecases/app_content_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../sticky_action_button_state.dart';

class QuickActionCubit extends Cubit<QuickActionState> {
  QuickActionCubit({required this.appContentUsecase})
      : super(StickyActionButtonInitialState());
  final AppContentUsecase appContentUsecase;

  void open() => emit(OpenState(isOpen: false));

  void closed() => emit(StickyActionButtonInitialState());

  void getTollFreeNum() async {
    try {
      final result = await appContentUsecase.call(NoParams());
      result.fold((l) => emit(StickyAtionButtonFailureState(error: l)),
          (r) => emit(StickyAtionButtonSuccessState(response: r)));
    } catch (e) {
      emit(StickyAtionButtonFailureState(error: NoDataFailure()));
    }
  }
}
