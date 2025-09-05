import 'package:core/config/error/failure.dart';
import 'package:core/config/network/dio_client.dart';
import 'package:core/config/network/network_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:lead_generation/config/network/api_endpoints.dart' as lead_gen;
import 'package:lead_generation/data/models/get_dealer_req.dart';
import 'package:lead_generation/data/models/get_dealer_resp.dart';
import 'package:lead_generation/data/models/get_make_model_req.dart';
import 'package:lead_generation/data/models/get_make_model_resp.dart';
import 'package:lead_generation/data/models/get_state_city_req.dart';
import 'package:lead_generation/data/models/get_state_city_resp.dart';
import 'package:lead_generation/data/models/lead_dealership_resp.dart';
import 'package:lead_generation/data/models/lead_products_resp.dart';
import '../models/create_lead_generation_request.dart';
import '../models/create_lead_generation_response.dart';

class LeadGenerationDatasource {
  DioClient dioClient;

  LeadGenerationDatasource({required this.dioClient});

  Future<Either<Failure, CreateLeadGenerationResponse>> createLeadGeneration(
      LeadGenerationRequest request) async {
      final response = await dioClient.postRequest(
          getMsApiUrl(lead_gen.ApiEndpoints.getLeadGeneration),
          converter: (response) => CreateLeadGenerationResponse.fromJson(
              response as Map<String, dynamic>),
          data: request.toJson());
      return response;
    }

  Future<Either<Failure, LeadProductsResp>> getProductsVal() async {
    final response = await dioClient.getRequest(
      getCMSApiUrl(lead_gen.ApiEndpoints.genericResponse,
          category: 'lead_products'),
      converter: (response) =>
          LeadProductsResp.fromJson(response as Map<String, dynamic>),
    );
    return response;
  }

  Future<Either<Failure, GetStateCityResp>> getStateCity(
      GetStateCityReq request) async {
    final response = await dioClient.postRequest(
        getMsApiUrl(lead_gen.ApiEndpoints.getPincode),
        converter: (response) =>
            GetStateCityResp.fromJson(response as Map<String, dynamic>),
        data: request.toJson());
    return response;
  }

  Future<Either<Failure, LeadVehicleDealerResp>> fetchDealershipList() async {
    final response = await dioClient.getRequest(
      getCMSApiUrl(lead_gen.ApiEndpoints.genericResponse,
          category: 'lead_vehicles'),
      converter: (response) =>
          LeadVehicleDealerResp.fromJson(response as Map<String, dynamic>),
    );

    return response;
  }

  Future<Either<Failure, GetMakeModelResp>> getMakeModel(
      GetMakeModelReq request) async {
    final response = await dioClient.postRequest(
        getMsApiUrl(lead_gen.ApiEndpoints.getMakeModel),
        converter: (response) =>
            GetMakeModelResp.fromJson(response as Map<String, dynamic>),
        data: request.toJson());

    return response;
  }

  Future<Either<Failure, GetDealerResp>> getDealers(
      GetDealerReq request) async {
    final response = await dioClient.postRequest(
        getMsApiUrl(lead_gen.ApiEndpoints.getDealers),
        converter: (response) =>
            GetDealerResp.fromJson(response as Map<String, dynamic>),
        data: request.toJson());
    return response;
  }
}
