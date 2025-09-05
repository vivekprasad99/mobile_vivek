import 'dart:io';

import 'package:ach/data/models/check_vpa_status_req.dart';
import 'package:ach/data/models/check_vpa_status_res.dart';
import 'package:ach/data/models/fetch_applicant_name_req.dart';
import 'package:ach/data/models/get_cms_bank_list_resp.dart';
import 'package:ach/data/models/get_preset_uri_request.dart';
import 'package:ach/data/models/name_match_req.dart';
import 'package:ach/data/models/name_match_resp.dart';
import 'package:ach/data/models/popular_bank_list_res.dart';
import 'package:ach/data/models/validate_vpa_req.dart';
import 'package:ach/data/models/validate_vpa_resp.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import '../../data/models/camps_output_req.dart';
import '../../data/models/camps_output_res.dart';
import '../../data/models/fetch_applicant_name_res.dart';
import '../../data/models/fetch_bank_accoun_response.dart';
import '../../data/models/fetch_bank_account_req.dart';
import '../../data/models/generate_mandate_request.dart';
import '../../data/models/generate_mandate_response.dart';
import '../../data/models/generate_upi_mandate_request.dart';
import '../../data/models/generate_upi_mandate_response.dart';
import '../../data/models/get_ach_loans_request.dart';
import '../../data/models/get_ach_loans_response.dart';
import '../../data/models/get_bank_list_resp.dart';
import '../../data/models/get_cancel_mandate_response.dart';
import '../../data/models/get_mandate_req.dart';
import '../../data/models/get_mandate_res.dart';
import '../../data/models/get_preset_uri_response.dart';
import '../../data/models/nupay_status_req.dart';
import '../../data/models/nupay_status_res.dart';
import '../../data/models/penny_drop_req.dart';
import '../../data/models/penny_drop_resp.dart';
import '../../data/models/update_mandate_reason_resp.dart';
import '../repositories/ach_repository.dart';

class AchUsecase
    extends UseCase<GetAchLoansResponse, GetAchLoansRequest> {
  final AchRepository achRepository;

  AchUsecase({required this.achRepository});

  @override
  Future<Either<Failure, GetAchLoansResponse>> call(
      GetAchLoansRequest params) async {
    return await achRepository.getLoansList(params);
  }

  Future<Either<Failure, FetchBankAccountResponse>> fetchBankAccount(
      FetchBankAccountRequest params) async {
    return await achRepository.fetchBankAccount(params);
  }

  Future<Either<Failure, GetBankListResponse>> getBankList() async {
    return await achRepository.getBankList();
  }

  Future<Either<Failure, GetCMSBankListResponse>> getCMSBankList() async {
    return await achRepository.getCMSBankList();
  }

  Future<Either<Failure, PopularBankListRes>> getPopularBankList() async {
    return await achRepository.getPopularBankList();
  }

  Future<Either<Failure, GetMandateResponse>> getMandates(
      GetMandateRequest req) async {
    return await achRepository.getMandates(req);
  }

  Future<Either<Failure, PennyDropResponse>> pennyDrop(
      PennyDropReq pennyDropReq) async {
    return await achRepository.pennyDrop(pennyDropReq);
  }

  Future<Either<Failure, GenerateMandateResponse>> generateMandateReq(
      GenerateMandateRequest req) async {
    return await achRepository.generateMandateReq(req);
  }

  Future<Either<Failure, GenerateUpiMandateResponse>> generateUpiMandateReq(
      GenerateUpiMandateRequest req) async {
    return await achRepository.generateUpiMandateReq(req);
  }

  Future<Either<Failure, GetCancelMandateReasonResponse>>
      getCancelMandateReason() async {
    return await achRepository.getCancelMandateReason();
  }

  Future<Either<Failure, UpdateMandateReasonResp>>
  getUpdateMandateReason() async {
    return await achRepository.getUpdateMandateReason();
  }

  Future<Either<Failure, GetPresetUriResponse>> getPresetUri(GetPresetUriRequest req) async {
    return await achRepository.getPresetUri(req);
  }

  Future<Either<Failure, String>> uploadDocument(String presetUrl, File file) async {
    return await achRepository.uploadDocument(presetUrl,file);
  }

  Future<Either<Failure, String>> deleteDocument(String presetUrl) async {
    return await achRepository.deleteDocument(presetUrl);
  }

  Future<Either<Failure, ValidateVpaResp>> validateVpa(
      ValidateVpaReq request) async {
    return await achRepository.validateVpa(request);
  }

  Future<Either<Failure, NameMatchRes>> validateName(
      NameMatchReq request) async {
    return await achRepository.validateName(request);
  }

  Future<Either<Failure, FetchApplicantNameRes>> fetchApplicantName(
      FetchApplicantNameReq request) async {
    return await achRepository.fetchApplicantName(request);
  }

  Future<Either<Failure, CheckVpaStatusRes>> checkVpaStatus(
      CheckVpaStatusReq request) async {
    return await achRepository.checkVpaStatus(request);
  }
  Future<Either<Failure, CampsOutputRes>> decryptCampsOutput(CampsOutputReq request) async {
    return await achRepository.decryptCampsOutput(request);
  }

  Future<Either<Failure, NupayStatusRes>> getNupayStatusById(NupayStatusReq request) async {
    return await achRepository.getNupayStatusById(request);
  }

}
