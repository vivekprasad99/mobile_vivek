import 'package:core/config/error/error.dart';
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

abstract class LocateUsRepository {
  Future<Either<Failure, GetStatesResponse>> getStates();
  Future<Either<Failure, GetCitiesResponse>> getCities(
    GetCitiesRequest req,
  );
  Future<Either<Failure, GetBranchesResponse>> getBranchesFromStateCity(
    GetBranchesStateCityRequest req,
  );
  Future<Either<Failure, GetBranchesResponse>> getBranchesFromPincode(
    GetBranchesPincodeRequest req,
  );
  Future<Either<Failure, GetBranchesResponse>> getBranchesFromLatLong(
    GetBranchesLatLongRequest req,
  );
  Future<Either<Failure, SaveBranchResponse>> saveBranch(
    SaveBranchRequest req,
  );
  Future<Either<Failure, GetBranchesResponse>> getSavedBranches(
    GetSavedBranchesReq req,
  );
}
