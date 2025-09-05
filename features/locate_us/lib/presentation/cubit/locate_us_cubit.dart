import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/utils.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locate_us/data/models/get_saved_branches_req.dart';
import 'package:meta/meta.dart';

import '../../data/models/get_branches_latlong_req.dart';
import '../../data/models/get_branches_pincode_req.dart';
import '../../data/models/get_branches_res.dart';
import '../../data/models/get_branches_state_city_req.dart';
import '../../data/models/get_cities_req.dart';
import '../../data/models/get_cities_res.dart';
import '../../data/models/get_states_res.dart';
import '../../data/models/save_branch_res.dart';
import '../../data/models/save_branches_req.dart';
import '../../domain/usecase/locate_us_usecase.dart';
import '../../locate_us.dart';

part 'locate_us_state.dart';

late GetBranchesResponse _branches;
late GetBranchesResponse _dealers;
late GetBranchesResponse _saved;

class LocateUsCubit extends Cubit<LocateUsState> {
  final LocateUsUseCase locateUsUsecase;

  LocateUsCubit({
    required this.locateUsUsecase,
  }) : super(LocateUsInitial());

  void getStates() async {
    try {
      emit(LoadingState(isLoading: true));
      final result = await locateUsUsecase.call(NoParams());
      emit(LoadingState(isLoading: false));
      result.fold((l) => emit(FailureState(failure: l)),
          (r) => emit(GetStateSuccessState(states: r)));
    } catch (e, st) {
      log.e('Error in getStates', error: e, stackTrace: st);
      emit(LoadingState(isLoading: false));
      emit(FailureState(failure: NoDataFailure()));
    }
  }

  void getCities(GetCitiesRequest req) async {
    try {
      emit(LoadingState(isLoading: true));
      final result = await locateUsUsecase.getCities(req);
      emit(LoadingState(isLoading: false));
      result.fold((l) => emit(FailureState(failure: l)),
          (r) => emit(GetCitiesSuccessState(cities: r)));
    } catch (e, st) {
      log.e('Error in getCities', error: e, stackTrace: st);
      emit(LoadingState(isLoading: false));
      emit(FailureState(failure: NoDataFailure()));
    }
  }

  Future<Either<Failure, SaveBranchResponse>> saveBranch(
    SaveBranchRequest req, {
    required Branch branch,
  }) async {
    try {
      final result = await locateUsUsecase.saveBranch(req);
      result.fold((l) => null, (r) {
        if (r.code != AppConst.codeFailure) {
          List<Branch> newSavedBranches = [];
          if (req.saveBranch) {
            newSavedBranches = [branch, ...(_saved.branchList ?? [])];
          } else {
            newSavedBranches = [...(_saved.branchList ?? [])];
            newSavedBranches.removeWhere((b) => b.code == branch.code);
          }
          _saved = _saved.copyWith(branchList: newSavedBranches);
          emit(GetBranchesSuccessState(
            branches: _branches,
            dealers: _dealers,
            saved: _saved.copyWith(branchList: newSavedBranches),
          ));
        }
      });

      return result;
    } catch (e, st) {
      log.e('Error in saveBranch', error: e, stackTrace: st);
      return left(NoDataFailure());
    }
  }

  bool isBranchSaved(Branch branch) {
    return _saved.branchList?.any((b) => branch.code == b.code) ?? false;
  }

  void getBranchesFromLatLong() async {
    final location = await LocateUsServices.determinePosition();
    if (location != null) {
      _getBranchesAndDealers(
        latLongReq: GetBranchesLatLongRequest(
          lat: location.latitude,
          lon: location.longitude,
        ),
      );
    }
  }

  void getBranchesFromStateCity({
    required GetBranchesStateCityRequest req,
  }) {
    req.onlyDealers
        ? _getDealers(stateCityReq: req)
        : _getBranchesAndDealers(stateCityReq: req);
  }

  void getBranchesFromPincode({
    required GetBranchesPincodeRequest req,
  }) {
    req.onlyDealers
        ? _getDealers(pincodeReq: req)
        : _getBranchesAndDealers(pincodeReq: req);
  }

  void _getDealers({
    GetBranchesStateCityRequest? stateCityReq,
    GetBranchesPincodeRequest? pincodeReq,
  }) async {
    try {
      Either<Failure, GetBranchesResponse> dealersResult;
      emit(LoadingState(isLoading: true));
      if (pincodeReq != null) {
        dealersResult = await locateUsUsecase
            .getBranchesFromPincode(pincodeReq.copyWith(isDealers: true));
      } else if (stateCityReq != null) {
        dealersResult = await locateUsUsecase
            .getBranchesFromStateCity(stateCityReq.copyWith(isDealers: true));
      } else {
        return;
      }
      emit(LoadingState(isLoading: false));
      dealersResult.fold(
        (l) => emit(FailureState(failure: l)),
        (r) {
          _dealers = r;
          emit(GetDealersSuccessState(dealers: r));
        },
      );
    } catch (e, st) {
      log.e('Error in getDealers', error: e, stackTrace: st);
      emit(LoadingState(isLoading: false));
      emit(FailureState(failure: NoDataFailure()));
    }
  }

  void _getBranchesAndDealers({
    GetBranchesLatLongRequest? latLongReq,
    GetBranchesStateCityRequest? stateCityReq,
    GetBranchesPincodeRequest? pincodeReq,
  }) async {
    try {
      Either<Failure, GetBranchesResponse> branchesResult;
      Either<Failure, GetBranchesResponse> dealersResult;
      Either<Failure, GetBranchesResponse> saved;
      emit(LoadingState(isLoading: true));
      if (pincodeReq != null) {
        [branchesResult, dealersResult, saved] = await Future.wait([
          //? fetch branch
          locateUsUsecase.getBranchesFromPincode(pincodeReq),

          //? fetch dealers
          locateUsUsecase
              .getBranchesFromPincode(pincodeReq.copyWith(isDealers: true)),

          //? fetch saved
          locateUsUsecase.getSavedBranches(
            GetSavedBranchesReq(superAppId: getSuperAppId()),
          ),
        ]);
      } else if (stateCityReq != null) {
        [branchesResult, dealersResult, saved] = await Future.wait([
          //? fetch branch
          locateUsUsecase.getBranchesFromStateCity(stateCityReq),

          //? fetch dealers
          locateUsUsecase
              .getBranchesFromStateCity(stateCityReq.copyWith(isDealers: true)),

          //? fetch saved
          locateUsUsecase.getSavedBranches(
            GetSavedBranchesReq(superAppId: getSuperAppId()),
          ),
        ]);
      } else if (latLongReq != null) {
        [branchesResult, dealersResult, saved] = await Future.wait([
          //? fetch branch
          locateUsUsecase.getBranchesFromLatLong(latLongReq),

          //? dealers not available for lat long
          Future.value(right(GetBranchesResponse(branchList: []))),

          //? fetch saved
          locateUsUsecase.getSavedBranches(
            GetSavedBranchesReq(superAppId: getSuperAppId()),
          ),
        ]);
      } else {
        return;
      }
      emit(LoadingState(isLoading: false));
      branchesResult.fold(
        (l) => emit(FailureState(failure: l)),
        (branches) {
          dealersResult.fold(
            (l) => emit(FailureState(failure: l)),
            (dealers) {
              saved.fold(
                (l) => emit(FailureState(failure: l)),
                (saved) {
                  _branches = branches;
                  _dealers = dealers;
                  _saved = saved;
                  emit(GetBranchesSuccessState(
                    branches: branches,
                    dealers: dealers,
                    saved: saved,
                  ));
                },
              );
            },
          );
        },
      );
    } catch (e, st) {
      log.e('Error in getBranches', error: e, stackTrace: st);
      emit(LoadingState(isLoading: false));
      emit(FailureState(failure: NoDataFailure()));
    }
  }

  void selectbranch(Branch? branch) {
    emit(SelectBranchState(branch: branch));
  }
}
