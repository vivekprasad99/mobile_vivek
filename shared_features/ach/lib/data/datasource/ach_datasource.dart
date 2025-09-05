import 'dart:convert';
import 'dart:io';
import 'package:ach/config/ach_const.dart';
import 'package:ach/config/network/api_endpoints.dart';
import 'package:ach/data/models/bank_list_req.dart';
import 'package:ach/data/models/check_vpa_status_req.dart';
import 'package:ach/data/models/check_vpa_status_res.dart';
import 'package:ach/data/models/fetch_applicant_name_req.dart';
import 'package:ach/data/models/get_cms_bank_list_resp.dart';
import 'package:ach/data/models/get_preset_uri_request.dart';
import 'package:ach/data/models/name_match_req.dart';
import 'package:ach/data/models/nupay_status_req.dart';
import 'package:ach/data/models/validate_vpa_req.dart';
import 'package:ach/data/models/validate_vpa_resp.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/flavor/feature_flag/feature_flag.dart';
import 'package:core/config/flavor/feature_flag/feature_flag_keys.dart';
import 'package:core/config/network/dio_client.dart';
import 'package:core/config/network/dio_client_doc_upload.dart';
import 'package:core/config/network/network_utils.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/utils.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import '../models/camps_output_req.dart';
import '../models/camps_output_res.dart';
import '../models/fetch_applicant_name_res.dart';
import '../models/fetch_bank_accoun_response.dart';
import '../models/fetch_bank_account_req.dart';
import '../models/generate_mandate_request.dart';
import '../models/generate_mandate_response.dart';
import '../models/generate_upi_mandate_request.dart';
import '../models/generate_upi_mandate_response.dart';
import '../models/get_ach_loans_request.dart';
import '../models/get_ach_loans_response.dart';
import '../models/get_bank_list_resp.dart';
import '../models/get_cancel_mandate_response.dart';
import '../models/get_mandate_req.dart';
import '../models/get_mandate_res.dart';
import '../models/get_preset_uri_response.dart';
import '../models/name_match_resp.dart';
import '../models/nupay_status_res.dart';
import '../models/penny_drop_req.dart';
import '../models/penny_drop_resp.dart';
import '../models/popular_bank_list_res.dart';
import '../models/update_mandate_reason_resp.dart';

class AchDatasource {
  DioClient dioClient;
  DioClientDocUpload dioClientUnc;
  AchDatasource({required this.dioClient, required this.dioClientUnc});
  // TODO remove after refund testing
  final bool refundTestingTemp = false;

  Future<Either<Failure, GetAchLoansResponse>> getLoansList(
      GetAchLoansRequest getAchLoansRequest) async {
    if (isFeatureEnabled(featureName: featureEnableStubData) ||
        refundTestingTemp) {
            final loginStubData = await rootBundle
          .loadString('assets/stubdata/ach/get_loans_list.json');
      final body = json.decode(loginStubData);
      Either<Failure, GetAchLoansResponse> response =
          Right(GetAchLoansResponse.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.getAchLoans),
          converter: (response) =>
              GetAchLoansResponse.fromJson(response as Map<String, dynamic>),
          data: getAchLoansRequest.toJson());
      return response;
    }
  }

  Future<Either<Failure, FetchBankAccountResponse>> fetchBankAccount(
      FetchBankAccountRequest fetchBankAccountRequest) async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
            final loginStubData = await rootBundle
          .loadString('assets/stubdata/ach/fetch_bank_accounts.json');
      final body = json.decode(loginStubData);
      Either<Failure, FetchBankAccountResponse> response = Right(
          FetchBankAccountResponse.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.fetchBankAccount),
          converter: (response) => FetchBankAccountResponse.fromJson(
              response as Map<String, dynamic>),
          data: fetchBankAccountRequest.toJson());
      return response;
    }
  }

  Future<Either<Failure, GetBankListResponse>> getBankList() async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
      final loginStubData = await rootBundle
          .loadString('assets/stubdata/ach/get_banks_list.json');
      final body = json.decode(loginStubData);
      Either<Failure, GetBankListResponse> response =
          Right(GetBankListResponse.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      BankListReq req =
          BankListReq(source: AppConst.source, superAppId: getSuperAppId());
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.getBankList),
          converter: (response) =>
              GetBankListResponse.fromJson(response as Map<String, dynamic>),
          data: req.toJson());
      return response;
    }
  }

  Future<Either<Failure, GetCMSBankListResponse>> getCMSBankList() async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
      final loginStubData = await rootBundle
          .loadString('assets/stubdata/ach/get_banks_list.json');
      final body = json.decode(loginStubData);
      Either<Failure, GetCMSBankListResponse> response =
          Right(GetCMSBankListResponse.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.getRequest(
          getCMSApiUrl(ApiEndpoints.getCMSBankList),
          converter: (response) => GetCMSBankListResponse.fromJson(
              response as Map<String, dynamic>));
      return response;
    }
  }

  Future<Either<Failure, PopularBankListRes>> getPopularBankList() async {
    if (isFeatureEnabled(featureName: featureEnableStubData) ||
        refundTestingTemp) {
      final loginStubData = await rootBundle
          .loadString('assets/stubdata/ach/get_banks_list.json');
      final body = json.decode(loginStubData);
      Either<Failure, PopularBankListRes> response =
          Right(PopularBankListRes.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.getRequest(
          getCMSApiUrl(ApiEndpoints.getCMSBankList),
          converter: (response) =>
              PopularBankListRes.fromJson(response as Map<String, dynamic>));
      return response;
    }
  }

  Future<Either<Failure, GetMandateResponse>> getMandates(
      GetMandateRequest req) async {
    if (isFeatureEnabled(featureName: featureEnableStubData) ||
        refundTestingTemp) {
      final loginStubData =
          await rootBundle.loadString('assets/stubdata/ach/get_mandates.json');
      final body = json.decode(loginStubData);
      Either<Failure, GetMandateResponse> response =
          Right(GetMandateResponse.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.getMandates),
          converter: (response) =>
              GetMandateResponse.fromJson(response as Map<String, dynamic>),
          data: req.toJson());
      return response;
    }
  }

  Future<Either<Failure, PennyDropResponse>> pennyDrop(
      PennyDropReq pennyDropReq) async {
    if (isFeatureEnabled(featureName: featureEnableStubData) ||
        refundTestingTemp) {
      final loginStubData = await rootBundle
          .loadString('assets/stubdata/ach/penny_drop_resp.json');
      final body = json.decode(loginStubData);
      Either<Failure, PennyDropResponse> response =
          Right(PennyDropResponse.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.pennyDrop),
          converter: (response) =>
              PennyDropResponse.fromJson(response as Map<String, dynamic>),
          data: pennyDropReq.toJson());
      return response;
    }
  }

  Future<Either<Failure, NameMatchRes>> validateName(
      NameMatchReq nameMatchReq) async {
    if (isFeatureEnabled(featureName: featureEnableStubData) ||
        refundTestingTemp) {
      final loginStubData =
          await rootBundle.loadString('assets/stubdata/ach/validate_name.json');
      final body = json.decode(loginStubData);
      Either<Failure, NameMatchRes> response =
          Right(NameMatchRes.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.validateName),
          converter: (response) =>
              NameMatchRes.fromJson(response as Map<String, dynamic>),
          data: nameMatchReq.toJson());
      return response;
    }
  }

  Future<Either<Failure, GenerateMandateResponse>> generateMandateReq(
      GenerateMandateRequest req) async {
    if (isFeatureEnabled(featureName: featureEnableStubData) ||
        refundTestingTemp) {
      final loginStubData = await rootBundle
          .loadString('assets/stubdata/ach/generate_mandate_resp.json');
      final body = json.decode(loginStubData);
      Either<Failure, GenerateMandateResponse> response =
          Right(GenerateMandateResponse.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.generateEMandateRequest),
          converter: (response) => GenerateMandateResponse.fromJson(
              response as Map<String, dynamic>),
          data: req.toJson());
      return response;
    }
  }

  Future<Either<Failure, GenerateUpiMandateResponse>> generateUpiMandateReq(
      GenerateUpiMandateRequest req) async {
    if (isFeatureEnabled(featureName: featureEnableStubData) ||
        refundTestingTemp) {
      final loginStubData = await rootBundle
          .loadString('assets/stubdata/ach/generate_upi_mandate_resp.json');
      final body = json.decode(loginStubData);
      Either<Failure, GenerateUpiMandateResponse> response = Right(
          GenerateUpiMandateResponse.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.generateUpiEMandateRequest),
          converter: (response) => GenerateUpiMandateResponse.fromJson(
              response as Map<String, dynamic>),
          data: req.toJson());
      return response;
    }
  }

  Future<Either<Failure, GetCancelMandateReasonResponse>>
      getCancelMandateReason() async {
    if (isFeatureEnabled(featureName: featureEnableStubData) ||
        refundTestingTemp) {
      final loginStubData = await rootBundle
          .loadString('assets/stubdata/ach/cancel_mandate_reason.json');
      final body = json.decode(loginStubData);
      Either<Failure, GetCancelMandateReasonResponse> response = Right(
        GetCancelMandateReasonResponse.fromJson(body as Map<String, dynamic>),
      );
      return response;
    } else {
      final response = await dioClient.getRequest(
          getCMSApiUrlWithOutLang(ApiEndpoints.getCancelMandateReason),
          converter: (response) => GetCancelMandateReasonResponse.fromJson(
              response as Map<String, dynamic>));
      return response;
    }
  }

  Future<Either<Failure, GetPresetUriResponse>> getPresetUri(
      GetPresetUriRequest request) async {
    if (isFeatureEnabled(featureName: featureEnableStubData) ||
        refundTestingTemp) {
      String fileName = request.useCase == AchConst.deleteDocument
          ? 'assets/stubdata/ach/get_preset_uri_delete.json'
          : 'assets/stubdata/ach/get_preset_uri.json';
      final loginStubData = await rootBundle.loadString(fileName);
      final body = json.decode(loginStubData);
      Either<Failure, GetPresetUriResponse> response =
          Right(GetPresetUriResponse.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.getPresetUri),
          converter: (response) =>
              GetPresetUriResponse.fromJson(response as Map<String, dynamic>),
          data: request.toJson());
      return response;
    }
  }

  Future<Either<Failure, String>> uploadDocument(
      String presetUri, File file) async {
    final response = await dioClientUnc.uploadDocument(presetUri, file);
    return response;
  }

  Future<Either<Failure, String>> deleteDocuments(String presetUri) async {
    final response = await dioClientUnc.deleteDocument(presetUri);
    return response;
  }

  Future<Either<Failure, UpdateMandateReasonResp>>
      getUpdateMandateReason() async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
      final loginStubData = await rootBundle
          .loadString('assets/stubdata/ach/update_mandate_reason.json');
      final body = json.decode(loginStubData);
      Either<Failure, UpdateMandateReasonResp> response = Right(
        UpdateMandateReasonResp.fromJson(body as Map<String, dynamic>),
      );
      return response;
    } else {
      final response = await dioClient.getRequest(
          getCMSApiUrlWithOutLang(ApiEndpoints.getUpdateMandateReason),
          converter: (response) => UpdateMandateReasonResp.fromJson(
              response as Map<String, dynamic>));
      return response;
    }
  }

  Future<Either<Failure, ValidateVpaResp>> validateVpa(
      ValidateVpaReq request) async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
      final loginStubData =
          await rootBundle.loadString('assets/stubdata/ach/validate_vpa.json');
      final body = json.decode(loginStubData);
      Either<Failure, ValidateVpaResp> response =
          Right(ValidateVpaResp.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.validvpa),
        converter: (response) =>
            ValidateVpaResp.fromJson(response as Map<String, dynamic>),
        data: request.toJson(),
      );
      return response;
    }
  }

  Future<Either<Failure, FetchApplicantNameRes>> fetchApplicantName(
      FetchApplicantNameReq request) async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
      final loginStubData = await rootBundle
          .loadString('assets/stubdata/ach/fetch_applicant_name.json');
      final body = json.decode(loginStubData);
      Either<Failure, FetchApplicantNameRes> response =
          Right(FetchApplicantNameRes.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.fetchApplicantName),
        converter: (response) =>
            FetchApplicantNameRes.fromJson(response as Map<String, dynamic>),
        data: request.toJson(),
      );
      return response;
    }
  }

  Future<Either<Failure, CheckVpaStatusRes>> checkVpaStatus(
      CheckVpaStatusReq request) async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
      final loginStubData = await rootBundle
          .loadString('assets/stubdata/ach/check_vpa_status.json');
      final body = json.decode(loginStubData);
      Either<Failure, CheckVpaStatusRes> response =
          Right(CheckVpaStatusRes.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.checkVpaStatus),
        converter: (response) =>
            CheckVpaStatusRes.fromJson(response as Map<String, dynamic>),
        data: request.toJson(),
      );
      return response;
    }
  }

  Future<Either<Failure, CampsOutputRes>> decryptCampsOutput(
      CampsOutputReq request) async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
      final loginStubData =
          await rootBundle.loadString('assets/stubdata/ach/camps_output.json');
      final body = json.decode(loginStubData);
      Either<Failure, CampsOutputRes> response =
          Right(CampsOutputRes.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.decryptCamsResponse),
        converter: (response) =>
            CampsOutputRes.fromJson(response as Map<String, dynamic>),
        data: request.toJson(),
      );
      return response;
    }
  }

  Future<Either<Failure, NupayStatusRes>> getNupayStatusById(
      NupayStatusReq request) async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
      final loginStubData = await rootBundle
          .loadString('assets/stubdata/ach/nupay_status_response.json');
      final body = json.decode(loginStubData);
      Either<Failure, NupayStatusRes> response =
          Right(NupayStatusRes.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.getNpayStatusById),
        converter: (response) =>
            NupayStatusRes.fromJson(response as Map<String, dynamic>),
        data: request.toJson(),
      );
      return response;
    }
  }
}
