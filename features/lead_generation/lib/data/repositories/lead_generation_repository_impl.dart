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
import '../../domain/repositories/lead_generation_repository.dart';
import '../datasource/lead_generation_datasource.dart';
import '../models/create_lead_generation_request.dart';
import '../models/create_lead_generation_response.dart';

class LeadGenerationRepositoryImpl extends LeadGenerationRepository {
  LeadGenerationRepositoryImpl({required this.datasource});
  final LeadGenerationDatasource datasource;

  @override
  Future<Either<Failure, CreateLeadGenerationResponse>> createLeadGeneration(
      LeadGenerationRequest leadGenRequest) async {
    final result = await datasource.createLeadGeneration(leadGenRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, GetStateCityResp>> getStateCity(
      GetStateCityReq request) async {
    final result = await datasource.getStateCity(request);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  // @override
  // Future<Either<Failure, FetchMakeListResponse>> fetchMakeList(
  //     FetchMakeListRequest leadGenRequest) async {
  //   final result = await datasource.fetchMakeList(leadGenRequest);
  //   return result.fold((left) => Left(left), (right) => Right(right));
  // }

  // @override
  // Future<Either<Failure, FetchModelListResponse>> fetchModelList(
  //     FetchModelListRequest leadGenRequest) async {
  //   final result = await datasource.fetchModelList(leadGenRequest);
  //   return result.fold((left) => Left(left), (right) => Right(right));
  // }

  @override
  Future<Either<Failure, LeadVehicleDealerResp>> fetchDealershipList() async {
    final result = await datasource.fetchDealershipList();
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, LeadProductsResp>> getProductsVal() async {
    final result = await datasource.getProductsVal();
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, GetDealerResp>> getDealers(
      GetDealerReq request) async {
    final result = await datasource.getDealers(request);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, GetMakeModelResp>> getMakeModel(
      GetMakeModelReq request) async {
    final result = await datasource.getMakeModel(request);
    return result.fold((left) => Left(left), (right) => Right(right));
  }
}
