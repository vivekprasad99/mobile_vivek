import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_route_state.dart';

class AppRouteCubit extends Cubit<AppRouteState> {
  AppRouteCubit(super.initialState);

  navigateToHomeScreen({required String from}) {
    emit(AppRouteHomePageNavigation(pathFrom: from));
  }
}
