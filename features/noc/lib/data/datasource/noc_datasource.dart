
import 'package:core/config/error/failure.dart';
import 'package:core/config/network/dio_client.dart';
import 'package:core/config/network/network_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:noc/config/network/api_endpoints.dart';
import 'package:noc/data/models/dl_noc_req.dart';
import 'package:noc/data/models/dl_noc_resp.dart';
import 'package:noc/data/models/gc_validate_req.dart';
import 'package:noc/data/models/get_fiance_resp.dart';
import 'package:noc/data/models/get_loan_list_req.dart';
import 'package:noc/data/models/get_loan_list_resp.dart';
import 'package:noc/data/models/get_vahan_details_req.dart';
import 'package:noc/data/models/get_vahan_details_resp.dart';
import 'package:noc/data/models/green_channel_validation_resp.dart';
import 'package:noc/data/models/noc_details_req.dart';
import 'package:noc/data/models/noc_details_resp.dart';
import 'package:noc/data/models/save_del_req.dart';
import 'package:noc/data/models/save_del_resp.dart';
import 'package:noc/data/models/update_rc_details_req.dart';

class NocDatasource {
  DioClient dioClient;

  NocDatasource({required this.dioClient});

  Future<Either<Failure, NocDetailsResponse>> getNocDetails(
      NocDetailsReq request) async {
    final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.getNocDetails),
        converter: (response) =>
            NocDetailsResponse.fromJson(response as Map<String, dynamic>),
        data: request.toJson());
    return response;
  }

  Future<Either<Failure, NocDetailsResponse>> updateRcDetails(
      UpdateRcDetailsReq request) async {
  
    final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.updateRc),
        converter: (response) =>
            NocDetailsResponse.fromJson(response as Map<String, dynamic>),
        data: request.toJson());
    return response;
  }

  Future<Either<Failure, GreenChannelValidationResp>> greenChannelValidation(
      GcValidateReq request) async {
  
    final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.gcvalidation),
        converter: (response) => GreenChannelValidationResp.fromJson(
            response as Map<String, dynamic>),
        data: request.toJson());
    return response;
  }

  Future<Either<Failure, GetLoanListResp>> getLoansList(
      GetLoanListReq request) async {
  
    final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.getLoanList),
        converter: (response) =>
            GetLoanListResp.fromJson(response as Map<String, dynamic>),
        data: request.toJson());
    return response;
  }

  Future<Either<Failure, GetFinacerNamesResp>> getFinanceMaster() async {
    final response = await dioClient.getRequest(
      getCMSApiUrl(ApiEndpoints.genericResponse, category: 'financers_list'),
      converter: (response) =>
          GetFinacerNamesResp.fromJson(response as Map<String, dynamic>),
    );
    return response;
  }

  Future<Either<Failure, GetVahanDetailsResp>> getVahanDetails(
      GetVahanDetailsReq req) async {
  
    final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.getVahanDetails),
        converter: (response) =>
            GetVahanDetailsResp.fromJson(response as Map<String, dynamic>),
        data: req.toJson());
    return response;
  }

  Future<Either<Failure, DlNocResp>> downloadNoc(DlNocReq req) async {
    final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.downloadNoc),
        converter: (response) =>
            DlNocResp.fromJson(response as Map<String, dynamic>),
        data: req.toJson());
    return response;
  }
  Future<Either<Failure,SaveDeliveryResp>> saveDeliveryResponse(SaveDeliveryReq req)async{
     final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.saveDeliveryAddress),
        converter: (response) =>
            SaveDeliveryResp.fromJson(response as Map<String, dynamic>),
        data: req.toJson());
    return response;
  }
}
