import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
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
import '../repositories/lead_generation_repository.dart';

class LeadGenerationUseCase
    extends UseCase<CreateLeadGenerationResponse, LeadGenerationRequest> {
  final LeadGenerationRepository leadGenerationRepository;

  LeadGenerationUseCase({required this.leadGenerationRepository});

  @override
  Future<Either<Failure, CreateLeadGenerationResponse>> call(
      LeadGenerationRequest params) async {
    return await leadGenerationRepository.createLeadGeneration(params);
  }

  Future<Either<Failure, GetStateCityResp>> getStateCity(
      GetStateCityReq params) async {
    return await leadGenerationRepository.getStateCity(params);
  }

  // Future<Either<Failure, FetchMakeListResponse>> fetchMakeList(
  //     FetchMakeListRequest params) async {
  //   return await leadGenerationRepository.fetchMakeList(params);
  // }

  // Future<Either<Failure, FetchModelListResponse>> fetchModelList(
  //     FetchModelListRequest params) async {
  //   return await leadGenerationRepository.fetchModelList(params);
  // }

  Future<Either<Failure, LeadVehicleDealerResp>> fetchDealershipList() async {
    return await leadGenerationRepository.fetchDealershipList();
  }

  Future<Either<Failure, LeadProductsResp>> getProductsVal() async {
    return await leadGenerationRepository.getProductsVal();
  }

  Future<Either<Failure, GetMakeModelResp>> getMakeModel(
      GetMakeModelReq request) async {
    return await leadGenerationRepository.getMakeModel(request);
  }

  Future<Either<Failure, GetDealerResp>> getDealers(
      GetDealerReq request) async {
    return await leadGenerationRepository.getDealers(request);
  }
}
