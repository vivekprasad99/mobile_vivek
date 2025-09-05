import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:locate_us/data/models/get_saved_branches_req.dart';

import '../../domain/repositories/locate_us_repository.dart';
import '../datasource/locate_us_datasource.dart';
import '../models/get_branches_latlong_req.dart';
import '../models/get_branches_pincode_req.dart';
import '../models/get_branches_res.dart';
import '../models/get_branches_state_city_req.dart';
import '../models/get_cities_req.dart';
import '../models/get_cities_res.dart';
import '../models/get_states_res.dart';
import '../models/save_branch_res.dart';
import '../models/save_branches_req.dart';

class LocateUsRepositoryImpl implements LocateUsRepository {
  LocateUsRepositoryImpl({required this.datasource});
  final LocateUsDataSource datasource;

  @override
  Future<Either<Failure, GetStatesResponse>> getStates() {
    return datasource.getStates();
  }

  @override
  Future<Either<Failure, GetCitiesResponse>> getCities(
    GetCitiesRequest req,
  ) {
    return datasource.getCities(req);
  }

  @override
  Future<Either<Failure, GetBranchesResponse>> getBranchesFromStateCity(
    GetBranchesStateCityRequest req,
  ) {
    return datasource.getBranchesFromStateCity(req);
  }

  @override
  Future<Either<Failure, GetBranchesResponse>> getBranchesFromPincode(
    GetBranchesPincodeRequest req,
  ) {
    return datasource.getBranchesFromPincode(req);
  }

  @override
  Future<Either<Failure, GetBranchesResponse>> getBranchesFromLatLong(
    GetBranchesLatLongRequest req,
  ) {
    return datasource.getBranchesFromLatLong(req);
  }

  @override
  Future<Either<Failure, SaveBranchResponse>> saveBranch(
    SaveBranchRequest req,
  ) {
    return datasource.saveBranch(req);
  }

  @override
  Future<Either<Failure, GetBranchesResponse>> getSavedBranches(
    GetSavedBranchesReq req,
  ) {
    return datasource.getSavedBranches(req);
  }
}
