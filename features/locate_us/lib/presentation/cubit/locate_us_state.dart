// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'locate_us_cubit.dart';

@immutable
sealed class LocateUsState extends Equatable {}

//? LocateUsInitial
class LocateUsInitial extends LocateUsState {
  @override
  List<Object?> get props => [];
}

//? LoadingState
class LoadingState extends LocateUsState {
  final bool isLoading;

  LoadingState({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}

//? GetStateSuccessState
class GetStateSuccessState extends LocateUsState {
  final GetStatesResponse states;
  GetStateSuccessState({required this.states});

  @override
  List<Object?> get props => [states];
}

//? FailureState
class FailureState extends LocateUsState {
  final Failure failure;

  FailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

//? GetCitiesSuccessState
class GetCitiesSuccessState extends LocateUsState {
  final GetCitiesResponse cities;
  GetCitiesSuccessState({required this.cities});

  @override
  List<Object?> get props => [cities];
}

//? GetBranchesSuccessState
class GetBranchesSuccessState extends LocateUsState {
  final GetBranchesResponse branches;
  final GetBranchesResponse dealers;
  final GetBranchesResponse saved;
  GetBranchesSuccessState({
    required this.branches,
    required this.dealers,
    required this.saved,
  });

  @override
  List<Object?> get props => [branches, dealers, saved];
}

class GetDealersSuccessState extends LocateUsState {
  final GetBranchesResponse dealers;
  GetDealersSuccessState({
    required this.dealers,
  });

  @override
  List<Object?> get props => [dealers];
}

class SaveBranchSuccessState extends LocateUsState {
  final SaveBranchResponse res;

  SaveBranchSuccessState({
    required this.res,
  });

  @override
  List<Object?> get props => [res];
}

class SaveBranchLoadingState extends LocateUsState {
  final bool isLoading;

  SaveBranchLoadingState({
    required this.isLoading,
  });

  @override
  List<Object?> get props => [isLoading];
}

class SelectBranchState extends LocateUsState {
  final Branch? branch;

  SelectBranchState({
    required this.branch,
  });
  @override
  List<Object?> get props => [branch];
}
