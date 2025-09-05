import 'dart:io';

import 'package:ach/data/models/check_vpa_status_req.dart';
import 'package:ach/data/models/check_vpa_status_res.dart';
import 'package:ach/data/models/fetch_applicant_name_req.dart';
import 'package:ach/data/models/generate_upi_mandate_request.dart';
import 'package:ach/data/models/get_preset_uri_request.dart';
import 'package:ach/data/models/name_match_req.dart';
import 'package:ach/data/models/name_match_resp.dart';
import 'package:ach/data/models/validate_vpa_req.dart';
import 'package:ach/data/models/validate_vpa_resp.dart';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import '../../data/models/camps_output_req.dart';
import '../../data/models/camps_output_res.dart';
import '../../data/models/fetch_applicant_name_res.dart';
import '../../data/models/fetch_bank_accoun_response.dart';
import '../../data/models/fetch_bank_account_req.dart';
import '../../data/models/generate_mandate_request.dart';
import '../../data/models/generate_mandate_response.dart';
import '../../data/models/generate_upi_mandate_response.dart';
import '../../data/models/get_ach_loans_request.dart';
import '../../data/models/get_ach_loans_response.dart';
import '../../data/models/get_bank_list_resp.dart';
import '../../data/models/get_cancel_mandate_response.dart';
import '../../data/models/get_cms_bank_list_resp.dart';
import '../../data/models/get_mandate_req.dart';
import '../../data/models/get_mandate_res.dart';
import '../../data/models/get_preset_uri_response.dart';
import '../../data/models/nupay_status_req.dart';
import '../../data/models/nupay_status_res.dart';
import '../../data/models/penny_drop_req.dart';
import '../../data/models/penny_drop_resp.dart';
import '../../data/models/popular_bank_list_res.dart';
import '../../data/models/update_mandate_reason_resp.dart';

abstract class AchRepository {
  Future<Either<Failure, GetAchLoansResponse>> getLoansList(
      GetAchLoansRequest getAchLoansRequest);

  Future<Either<Failure, FetchBankAccountResponse>> fetchBankAccount(
      FetchBankAccountRequest fetchBankAccountRequest);

  Future<Either<Failure, GetBankListResponse>> getBankList();
  Future<Either<Failure, GetCMSBankListResponse>> getCMSBankList();
  Future<Either<Failure, PopularBankListRes>> getPopularBankList();

  Future<Either<Failure, GetMandateResponse>> getMandates(
      GetMandateRequest req);

  Future<Either<Failure, PennyDropResponse>> pennyDrop(
      PennyDropReq pennyDropReq);

  Future<Either<Failure, GenerateMandateResponse>> generateMandateReq(
      GenerateMandateRequest req);
  Future<Either<Failure, GenerateUpiMandateResponse>> generateUpiMandateReq(
      GenerateUpiMandateRequest req);
  Future<Either<Failure, GetPresetUriResponse>> getPresetUri(GetPresetUriRequest req);
  Future<Either<Failure, GetCancelMandateReasonResponse>>
      getCancelMandateReason();
  Future<Either<Failure, UpdateMandateReasonResp>>
      getUpdateMandateReason();
  Future<Either<Failure, ValidateVpaResp>> validateVpa(
    ValidateVpaReq request,
  );
  Future<Either<Failure, String>> uploadDocument(String presetUri, File file);

  Future<Either<Failure, String>> deleteDocument(String presetUri);
  Future<Either<Failure, NameMatchRes>> validateName(NameMatchReq nameMatchReq);
  Future<Either<Failure, FetchApplicantNameRes>> fetchApplicantName(FetchApplicantNameReq request);
  Future<Either<Failure, CheckVpaStatusRes>> checkVpaStatus(CheckVpaStatusReq request);
  Future<Either<Failure, CampsOutputRes>> decryptCampsOutput(CampsOutputReq request);
  Future<Either<Failure, NupayStatusRes>> getNupayStatusById(NupayStatusReq request);
}
