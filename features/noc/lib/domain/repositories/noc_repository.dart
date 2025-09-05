import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
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

abstract class NocRepository {
  Future<Either<Failure, NocDetailsResponse>> getNocDetails(
      NocDetailsReq request);
  Future<Either<Failure, NocDetailsResponse>> updateRcDetails(
      UpdateRcDetailsReq request);
  Future<Either<Failure, GreenChannelValidationResp>> greenChannelValidation(
      GcValidateReq request);
  Future<Either<Failure, GetLoanListResp>> getLoansList(GetLoanListReq request);
  Future<Either<Failure, GetFinacerNamesResp>> getFinanceMaster();
  Future<Either<Failure, GetVahanDetailsResp>> getVahanDetails(
      GetVahanDetailsReq req);
  Future<Either<Failure, DlNocResp>> downloadNoc(DlNocReq req);
  Future<Either<Failure,SaveDeliveryResp>> saveDeliveryResponse(SaveDeliveryReq req);
}
