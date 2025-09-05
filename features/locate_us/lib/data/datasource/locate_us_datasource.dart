import 'package:core/config/error/failure.dart';
import 'package:core/config/network/dio_client.dart';
import 'package:core/config/network/network_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:locate_us/data/models/get_saved_branches_req.dart';
import '../../config/network/endpoints.dart';
import '../models/get_branches_latlong_req.dart';
import '../models/get_branches_pincode_req.dart';
import '../models/get_branches_res.dart';
import '../models/get_branches_state_city_req.dart';
import '../models/get_cities_req.dart';
import '../models/get_cities_res.dart';
import '../models/get_states_res.dart';
import '../models/save_branch_res.dart';
import '../models/save_branches_req.dart';

class LocateUsDataSource {
  final DioClient dioClient;

  LocateUsDataSource({
    required this.dioClient,
  });

  Future<Either<Failure, GetStatesResponse>> getStates() async {
      final response = await dioClient.getRequest(
        getMsApiUrl(ApiEndpoints.getStates),
        converter: (response) =>
            GetStatesResponse.fromJson(response as Map<String, dynamic>),
      );
      return response;
    }

  Future<Either<Failure, GetCitiesResponse>> getCities(
    GetCitiesRequest req,
  ) async {
      final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.getCities),
        data: req.toJson(),
        converter: (response) =>
            GetCitiesResponse.fromJson(response as Map<String, dynamic>),
      );
      return response;
    }

  Future<Either<Failure, GetBranchesResponse>> getBranchesFromStateCity(
    GetBranchesStateCityRequest req,
  ) async {
      final response = await dioClient.postRequest(
        getMsApiUrl(
          req.isDealers
              ? ApiEndpoints.getDealersStateCity
              : ApiEndpoints.getBranchesStateCity,
        ),
        data: req.toJson(),
        converter: (response) {
          if (req.isDealers) {
            return GetBranchesResponse.fromDealerJson(
                response as Map<String, dynamic>);
          }
          return GetBranchesResponse.fromJson(response as Map<String, dynamic>);
        },
      );
      return response;
    }

  Future<Either<Failure, GetBranchesResponse>> getBranchesFromPincode(
    GetBranchesPincodeRequest req,
  ) async {
      final response = await dioClient.postRequest(
        getMsApiUrl(
          req.isDealers
              ? ApiEndpoints.getDealersPincode
              : ApiEndpoints.getBranchesPincode,
        ),
        data: req.toJson(),
        converter: (response) {
          if (req.isDealers) {
            return GetBranchesResponse.fromDealerJson(
                response as Map<String, dynamic>);
          }
          return GetBranchesResponse.fromJson(response as Map<String, dynamic>);
        },
      );
      return response;
    }

  Future<Either<Failure, GetBranchesResponse>> getBranchesFromLatLong(
    GetBranchesLatLongRequest req,
  ) async {
      final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.getBranchesLatLong),
        data: req.toJson(),
        converter: (response) {
          return GetBranchesResponse.fromJson(response as Map<String, dynamic>);
        },
      );
      return response;
    }

  Future<Either<Failure, SaveBranchResponse>> saveBranch(
    SaveBranchRequest req,
  ) async {
      final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.saveBranch),
        data: req.toJson(),
        converter: (response) {
          return SaveBranchResponse.fromJson(response as Map<String, dynamic>);
        },
      );
      return response;
    }

  Future<Either<Failure, GetBranchesResponse>> getSavedBranches(
    GetSavedBranchesReq req,
  ) async {
      final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.getSavedBranches),
        data: req.toJson(),
        converter: (response) {
          final branches =
              GetBranchesResponse.fromJson(response as Map<String, dynamic>);
          final dealers = GetBranchesResponse.fromDealerJson(response);
          final combined = branches.copyWith(branchList: [
            ...branches.branchList ?? [],
            ...dealers.branchList ?? []
          ]);
          return combined;
        },
      );
      return response;
    }
  }
