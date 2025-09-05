import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:noc/data/datasource/noc_datasource.dart';
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
import 'package:noc/domain/repositories/noc_repository.dart';

class NocRepositoryImpl implements NocRepository {
  NocRepositoryImpl({required this.datasource});
  final NocDatasource datasource;
  @override
  Future<Either<Failure, NocDetailsResponse>> getNocDetails(
      NocDetailsReq request) async {
    final result = await datasource.getNocDetails(request);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, GreenChannelValidationResp>> greenChannelValidation(
      GcValidateReq request) async {
    final result = await datasource.greenChannelValidation(request);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, NocDetailsResponse>> updateRcDetails(
      UpdateRcDetailsReq request) async {
    final result = await datasource.updateRcDetails(request);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, GetFinacerNamesResp>> getFinanceMaster() async {
    final result = await datasource.getFinanceMaster();
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, GetLoanListResp>> getLoansList(
      GetLoanListReq request) async {
    final result = await datasource.getLoansList(request);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, GetVahanDetailsResp>> getVahanDetails(
      GetVahanDetailsReq req) async {
    final result = await datasource.getVahanDetails(req);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, DlNocResp>> downloadNoc(DlNocReq req) async {
    final result = await datasource.downloadNoc(req);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, SaveDeliveryResp>> saveDeliveryResponse(SaveDeliveryReq req) async{
    final result = await datasource.saveDeliveryResponse(req);
    return result.fold((left) => Left(left), (right) => Right(right));
  }
}
