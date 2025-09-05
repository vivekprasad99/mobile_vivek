import 'package:bloc/bloc.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
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
import 'package:noc/domain/usecases/noc_usecase.dart';

part 'noc_state.dart';

class NocCubit extends Cubit<NocState> {
  final NocUsecase nocUsecase;
  NocCubit({required this.nocUsecase}) : super(NocInitial());
  void getNocDetails(NocDetailsReq request) async {
    try {
      emit(LoadingState());
      final result = await nocUsecase.call(request);
      result.fold((l) => emit(GetNocDetailsFailureState(failure: l)),
          (r) => emit(GetNocDetailsSuccessState(response: r)));
    } catch (e) {
      emit(GetNocDetailsFailureState(failure: NoDataFailure()));
    }
  }

  void updateRcDetails(UpdateRcDetailsReq request, NocData nocData) async {
    try {
      emit(UpdateRCLoadingState());
      final result = await nocUsecase.updateRcDetails(request);
      result.fold((l) => emit(UpdateRcDetailsFailureState(failure: l)), (r) {
        nocData = nocData.copyWith(
            registrationNo: request.rcNumber,
            isEngineMatched: r.data?.isEngineMatched,
            isChassisMatched: r.data?.isChassisMatched,
            isCustNameMatched: r.data?.isCustNameMatched,
            isFinancerMatched: r.data?.isFinancerMatched);
        r = r.copyWith(data: nocData);
        emit(GetNocDetailsSuccessState(response: r));
      });
    } catch (e) {
      emit(UpdateRcDetailsFailureState(failure: NoDataFailure()));
    }
  }

  void greenChannelValidationtails(GcValidateReq request, LoanData data) async {
    try {
      emit(GreenChannelLoading());
      final result = await nocUsecase.greenChannelValidation(request);
      result.fold(
        (l) => emit(GreenChannelValidationFailureState(failure: l)),
        (r) =>
            emit(GreenChannelValidationSuccessState(response: r, data: data)),
      );
    } catch (e) {
      emit(GreenChannelValidationFailureState(failure: NoDataFailure()));
    }
  }

  void cancelUpdateRc() {
    emit(UpdateRcInitState());
  }

  void getFinanceMaster() async {
    try {
      emit(LoadingState());
      final result = await nocUsecase.getFinanceMaster();
      result.fold((l) => emit(FinanceMasterSFailureState(failure: l)),
          (r) => emit(FinanceMasterSuccessState(response: r)));
    } catch (e) {
      emit(FinanceMasterSFailureState(failure: NoDataFailure()));
    }
  }

  void getLoansList(GetLoanListReq request) async {
    try {
      emit(LoadingState());
      final result = await nocUsecase.getLoansList(request);
      result.fold(
          (l) => emit(GetLoansListFailureState(failure: l)),
          (r) => emit(GetLoansListSuccessState(
              response: r,
              vehicleLoans: r.data
                  ?.where((element) =>
                      element.productCategory
                          ?.equalsIgnoreCase("vehicle loan") ??
                      false)
                  .toList(),
              rcUpdateLoans: r.data
                  ?.where((element) =>
                      (element.productCategory
                              ?.equalsIgnoreCase("vehicle loan") ??
                          false) &&
                      element.vehicleRegistration == null)
                  .toList())));
    } catch (e) {
      emit(GetLoansListFailureState(failure: NoDataFailure()));
    }
  }

  void getVahanDetails(GetVahanDetailsReq req) async {
    try {
      emit(LoadingState());
      final result = await nocUsecase.getVahanDetails(req);
      result.fold((l) => emit(GetVahanDetailsFailureState(failure: l)),
          (r) => emit(GetVahanDetailsSuccessState(response: r)));
    } catch (e) {
      emit(GetVahanDetailsFailureState(failure: NoDataFailure()));
    }
  }

  void setNocItem(LoanData? loanItem, String query) {
    emit(SelectNocItem(loanData: loanItem, query: query));
  }

  void selectQuery(String query) {
    emit(SelectQueryState(query: query));
  }

  void downloadNoc(DlNocReq req) async {
    try {
      emit(DownloadNocLoading());
      final result = await nocUsecase.downloadNoc(req);
      result.fold((l) => emit(DownloadNocFailuretate(failure: l)),
          (r) => emit(DownloadNocSuccessState(response: r)));
    } catch (e) {
      emit(DownloadNocFailuretate(failure: NoDataFailure()));
    }
  }

  void selectPreferredMethod(PreferredMethod preferredMethod,String loanNumber) {
    emit(PreferredMethodState(preferredMethod: preferredMethod,loanNumber: loanNumber));
  }

  void selectedPrefferedAddress<T>(T? address, String? addressType,String loanNumber) {
    emit(SelectedPrefferedAddressState(
        address: address, addressType: addressType,loanNumber: loanNumber));
  }
  
  void saveDeliveryResponse<T>(SaveDeliveryReq req,T? address,)async{
     try {
      emit(SaveDeliveryLoadingState(isLoading: true));
      final result = await nocUsecase.saveDeliveryResponse(req);
      emit(SaveDeliveryLoadingState(isLoading: false));
      result.fold((l) => emit(SaveDeliveryFailuretate(failure: l)),
          (r) => emit(SaveDeliverySuccessState(response: r,address: address)));
    } catch (e) {
      emit(SaveDeliveryLoadingState(isLoading: false));
      emit(SaveDeliveryFailuretate(failure: NoDataFailure()));
    }
  }
}

enum PreferredMethod { branch, address }
