import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:locate_us/data/models/get_saved_branches_req.dart';

import '../../data/models/get_branches_latlong_req.dart';
import '../../data/models/get_branches_pincode_req.dart';
import '../../data/models/get_branches_res.dart';
import '../../data/models/get_branches_state_city_req.dart';
import '../../data/models/get_cities_req.dart';
import '../../data/models/get_cities_res.dart';
import '../../data/models/get_states_res.dart';
import '../../data/models/save_branch_res.dart';
import '../../data/models/save_branches_req.dart';
import '../repositories/locate_us_repository.dart';

class LocateUsUseCase extends UseCase<GetStatesResponse, NoParams> {
  final LocateUsRepository locateUsRepository;

  LocateUsUseCase({
    required this.locateUsRepository,
  });

  @override
  Future<Either<Failure, GetStatesResponse>> call(NoParams params) {
    return locateUsRepository.getStates();
  }

  Future<Either<Failure, GetCitiesResponse>> getCities(GetCitiesRequest req) {
    return locateUsRepository.getCities(req);
  }

  Future<Either<Failure, GetBranchesResponse>> getBranchesFromStateCity(
    GetBranchesStateCityRequest req,
  ) {
    return locateUsRepository.getBranchesFromStateCity(req);
  }

  Future<Either<Failure, GetBranchesResponse>> getBranchesFromPincode(
    GetBranchesPincodeRequest req,
  ) {
    return locateUsRepository.getBranchesFromPincode(req);
  }

  Future<Either<Failure, GetBranchesResponse>> getBranchesFromLatLong(
    GetBranchesLatLongRequest req,
  ) {
    return locateUsRepository.getBranchesFromLatLong(req);
  }

  Future<Either<Failure, GetBranchesResponse>> getSavedBranchesDealers(
    GetBranchesLatLongRequest req,
  ) {
    return locateUsRepository.getBranchesFromLatLong(req);
  }

  Future<Either<Failure, SaveBranchResponse>> saveBranch(
    SaveBranchRequest req,
  ) {
    return locateUsRepository.saveBranch(req);
  }

  Future<Either<Failure, GetBranchesResponse>> getSavedBranches(
    GetSavedBranchesReq req,
  ) {
    return locateUsRepository.getSavedBranches(req);
  }
}
