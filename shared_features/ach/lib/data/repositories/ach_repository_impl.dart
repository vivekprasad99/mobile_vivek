// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:ach/data/models/check_vpa_status_req.dart';
import 'package:ach/data/models/check_vpa_status_res.dart';
import 'package:ach/data/models/fetch_applicant_name_req.dart';
import 'package:ach/data/models/fetch_applicant_name_res.dart';
import 'package:ach/data/models/generate_upi_mandate_request.dart';
import 'package:ach/data/models/generate_upi_mandate_response.dart';
import 'package:ach/data/models/get_cms_bank_list_resp.dart';
import 'package:ach/data/models/get_preset_uri_request.dart';
import 'package:ach/data/models/name_match_req.dart';
import 'package:ach/data/models/name_match_resp.dart';
import 'package:ach/data/models/nupay_status_req.dart';
import 'package:ach/data/models/nupay_status_res.dart';
import 'package:ach/data/models/popular_bank_list_res.dart';
import 'package:ach/data/models/validate_vpa_req.dart';
import 'package:ach/data/models/validate_vpa_resp.dart';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import '../datasource/ach_datasource.dart';
import '../models/camps_output_req.dart';
import '../models/camps_output_res.dart';
import '../models/fetch_bank_accoun_response.dart';
import '../models/fetch_bank_account_req.dart';
import '../models/generate_mandate_request.dart';
import '../models/generate_mandate_response.dart';
import '../models/get_ach_loans_request.dart';
import '../models/get_ach_loans_response.dart';
import '../models/get_bank_list_resp.dart';
import '../models/get_cancel_mandate_response.dart';
import '../models/get_mandate_req.dart';
import '../models/get_mandate_res.dart';
import '../models/get_preset_uri_response.dart';
import '../models/penny_drop_req.dart';
import '../models/penny_drop_resp.dart';
import '../models/update_mandate_reason_resp.dart';

import '../../domain/repositories/ach_repository.dart';

class AchRepositoryImpl extends AchRepository {
  final AchDatasource datasource;
  AchRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<Either<Failure, FetchBankAccountResponse>> fetchBankAccount(
      FetchBankAccountRequest fetchBankAccountRequest) async {
    final result = await datasource.fetchBankAccount(fetchBankAccountRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, GetBankListResponse>> getBankList() async {
    final result = await datasource.getBankList();
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, GetAchLoansResponse>> getLoansList(
      GetAchLoansRequest getAchLoansRequest) async {
    final result = await datasource.getLoansList(getAchLoansRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, GetMandateResponse>> getMandates(
      GetMandateRequest req) async {
    final result = await datasource.getMandates(req);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, PennyDropResponse>> pennyDrop(
      PennyDropReq pennyDropReq) async {
    final result = await datasource.pennyDrop(pennyDropReq);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, GenerateMandateResponse>> generateMandateReq(
      GenerateMandateRequest req) async {
    final result = await datasource.generateMandateReq(req);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, GenerateUpiMandateResponse>> generateUpiMandateReq(GenerateUpiMandateRequest req) async {
    final result = await datasource.generateUpiMandateReq(req);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, GetCancelMandateReasonResponse>>
      getCancelMandateReason() async {
    final result = await datasource.getCancelMandateReason();
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, UpdateMandateReasonResp>>
      getUpdateMandateReason() async {
    final result = await datasource.getUpdateMandateReason();
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, ValidateVpaResp>> validateVpa(
      ValidateVpaReq request) async {
    final result = await datasource.validateVpa(request);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, GetPresetUriResponse>> getPresetUri(GetPresetUriRequest req) async {
    final result = await datasource.getPresetUri(req);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, String>> uploadDocument(String presetUri, File file) async{
    final result = await datasource.uploadDocument(presetUri,file);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, String>> deleteDocument(String presetUri) async{
    final result = await datasource.deleteDocuments(presetUri);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, NameMatchRes>> validateName(NameMatchReq nameMatchReq) async{
    final result = await datasource.validateName(nameMatchReq);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, FetchApplicantNameRes>> fetchApplicantName(FetchApplicantNameReq request) async{
    final result = await datasource.fetchApplicantName(request);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, CheckVpaStatusRes>> checkVpaStatus(CheckVpaStatusReq request) async {
    final result = await datasource.checkVpaStatus(request);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, CampsOutputRes>> decryptCampsOutput(CampsOutputReq request) async {
    final result = await datasource.decryptCampsOutput(request);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, NupayStatusRes>> getNupayStatusById(NupayStatusReq request) async {
    final result = await datasource.getNupayStatusById(request);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, GetCMSBankListResponse>> getCMSBankList() async {
    final result = await datasource.getCMSBankList();
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, PopularBankListRes>> getPopularBankList() async {
    final result = await datasource.getPopularBankList();
    return result.fold((left) => Left(left), (right) => Right(right));
  }
}
