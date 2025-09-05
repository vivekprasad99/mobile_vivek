import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
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
import 'package:noc/domain/repositories/noc_repository.dart';

class NocUsecase extends UseCase<NocDetailsResponse, NocDetailsReq> {
  final NocRepository nocRepository;

  NocUsecase({required this.nocRepository});

  @override
  Future<Either<Failure, NocDetailsResponse>> call(NocDetailsReq params) async {
    return await nocRepository.getNocDetails(params);
  }

  Future<Either<Failure, NocDetailsResponse>> updateRcDetails(
      UpdateRcDetailsReq params) async {
    return await nocRepository.updateRcDetails(params);
  }

  Future<Either<Failure, GreenChannelValidationResp>> greenChannelValidation(
      GcValidateReq params) async {
    return await nocRepository.greenChannelValidation(params);
  }

  Future<Either<Failure, GetFinacerNamesResp>> getFinanceMaster() async {
    return await nocRepository.getFinanceMaster();
  }

  Future<Either<Failure, GetLoanListResp>> getLoansList(
      GetLoanListReq params) async {
    return await nocRepository.getLoansList(params);
  }

  Future<Either<Failure, GetVahanDetailsResp>> getVahanDetails(
      GetVahanDetailsReq params) async {
    return await nocRepository.getVahanDetails(params);
  }

  Future<Either<Failure, DlNocResp>> downloadNoc(DlNocReq req) async {
    return await nocRepository.downloadNoc(req);
  }
  Future<Either<Failure,SaveDeliveryResp>> saveDeliveryResponse(SaveDeliveryReq req)async{
     return await nocRepository.saveDeliveryResponse(req);
  }
}
