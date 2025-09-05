import 'package:common/features/home/data/models/logout_response.dart';
import 'package:common/features/home/data/models/update_theme_response.dart';
import 'package:core/config/error/failure.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class LoadingState extends HomeState {
  final bool isLoading;
  LoadingState({required this.isLoading});

  List<Object?> get props => [isLoading];
}

class UpdateThemeSuccess extends HomeState {
  final UpdateThemeResponse response;

  UpdateThemeSuccess({required this.response});
}

class UpdateThemeFailure extends HomeState {
  final Failure error;

  UpdateThemeFailure({required this.error});
}

class UpdateSelectedTab extends HomeState {
  final String selectedItem;

  UpdateSelectedTab({required this.selectedItem});
}

class LogoutResSuccessState extends HomeState {
  final LogoutResponse resp;

  LogoutResSuccessState({required this.resp});
  List<Object?> get props => [resp];
}

class LogoutResFailureState extends HomeState {
  final Failure error;

  LogoutResFailureState({required this.error});
  List<Object?> get props => [error];
}
