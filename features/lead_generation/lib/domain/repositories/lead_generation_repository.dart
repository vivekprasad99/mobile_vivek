import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:lead_generation/data/models/get_dealer_req.dart';
import 'package:lead_generation/data/models/get_dealer_resp.dart';
import 'package:lead_generation/data/models/get_make_model_req.dart';
import 'package:lead_generation/data/models/get_make_model_resp.dart';
import 'package:lead_generation/data/models/get_state_city_req.dart';
import 'package:lead_generation/data/models/get_state_city_resp.dart';
import 'package:lead_generation/data/models/lead_dealership_resp.dart';
import 'package:lead_generation/data/models/lead_products_resp.dart';
import '../../data/models/create_lead_generation_request.dart';
import '../../data/models/create_lead_generation_response.dart';

abstract class LeadGenerationRepository {
  Future<Either<Failure, CreateLeadGenerationResponse>> createLeadGeneration(
      LeadGenerationRequest leadGenRequest);

  Future<Either<Failure, GetStateCityResp>> getStateCity(
      GetStateCityReq request);

  // Future<Either<Failure, FetchMakeListResponse>> fetchMakeList(
  //     FetchMakeListRequest leadGenRequest);

  // Future<Either<Failure, FetchModelListResponse>> fetchModelList(
  //     FetchModelListRequest leadGenRequest);

  Future<Either<Failure, LeadVehicleDealerResp>> fetchDealershipList();
  Future<Either<Failure, LeadProductsResp>> getProductsVal();
  Future<Either<Failure, GetMakeModelResp>> getMakeModel(
      GetMakeModelReq request);
  Future<Either<Failure, GetDealerResp>> getDealers(GetDealerReq request);
}
