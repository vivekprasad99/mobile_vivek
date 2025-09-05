import 'package:core/config/config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lead_generation/data/models/get_dealer_req.dart';
import 'package:lead_generation/data/models/get_dealer_resp.dart';
import 'package:lead_generation/data/models/get_make_model_req.dart';
import 'package:lead_generation/data/models/get_make_model_resp.dart';
import 'package:lead_generation/data/models/get_state_city_req.dart';
import '../../data/models/create_lead_generation_request.dart';
import '../../domain/usecases/lead_generation_usecase.dart';
import 'lead_generation_state.dart';

class LeadGenerationCubit extends Cubit<LeadGenerationState> {
  final LeadGenerationUseCase leadGenerationUseCase;
  LeadGenerationCubit({required this.leadGenerationUseCase})
      : super(LeadGenerationInitial()) {
    validateInput(false);
  }

  createLeadGeneration(
      {required LeadGenerationRequest applicationStatusRequest}) async {
    try {
      emit(LoadingState(isLoading: true));
      final result = await leadGenerationUseCase.call(applicationStatusRequest);
      emit(LoadingState(isLoading: false));
      result.fold((l) => emit(LeadGenerationFailureState(error: l)),
          (r) => emit(LeadGenerationSuccessState(response: r)));
    } catch (e) {
      emit(LoadingState(isLoading: false));
      emit(LeadGenerationFailureState(error: NoDataFailure()));
    }
  }

  validateInput(bool isValid) {
    emit(ValidateState(isValid: isValid));
  }

  getStateCity(GetStateCityReq req) async {
    try {
      emit(LoadingState(isLoading: true));
      final result = await leadGenerationUseCase.getStateCity(req);
      emit(LoadingState(isLoading: false));
      result.fold((l) => emit(FetchPinCodeFailureState(error: l)),
          (r) => emit(FetchPinCodeSuccessState(response: r)));
    } catch (e) {
      emit(LoadingState(isLoading: false));
      emit(FetchPinCodeFailureState(error: NoDataFailure()));
    }
  }

  void submitActionPressed(
      {required LeadGenerationRequest leadGenerationRequest}) {
    submitLeadGen(
      leadGenerationRequest: leadGenerationRequest,
    );
  }

  submitLeadGen({
    required LeadGenerationRequest leadGenerationRequest,
  }) async {
    try {
      emit(LoadingState(isLoading: true));
      final result = await leadGenerationUseCase.call(leadGenerationRequest);
      emit(LoadingState(isLoading: false));
      result.fold((l) => emit(LeadGenerationFailureState(error: l)),
          (r) => emit(LeadGenerationSuccessState(response: r)));
    } catch (e) {
      emit(LoadingState(isLoading: false));
      emit(LeadGenerationFailureState(error: NoDataFailure()));
    }
  }

  fetchDealershipList() async {
    try {
      emit(LoadingState(isLoading: true));
      final result = await leadGenerationUseCase.fetchDealershipList();
      emit(LoadingState(isLoading: false));
      result.fold((l) => emit(FetchDealershipListFailureState(error: l)),
          (r) => emit(FetchDealershipListSuccessState(response: r)));
    } catch (e) {
      emit(LoadingState(isLoading: false));
      emit(FetchDealershipListFailureState(error: NoDataFailure()));
    }
  }

  void getProductsVal() async {
    try {
      emit(LoadingState(isLoading: true));
      final result = await leadGenerationUseCase.getProductsVal();
      emit(LoadingState(isLoading: false));
      result.fold((l) => emit(FetchInsuranceProductsFailureState(error: l)),
          (r) => emit(FetchInsuranceProductsSuccessState(response: r)));
    } catch (e) {
      emit(LoadingState(isLoading: false));
      emit(FetchInsuranceProductsFailureState(error: NoDataFailure()));
    }
  }

  void selectNewMakeModel(MakeModelData? makeModel) {
    emit(SelectMakeModelState(makeModel: makeModel));
  }

  void selectNewDealer(DealersData? dealer) {
    emit(SelectDealerShipState(dealer: dealer));
  }

  void getMakeModel(GetMakeModelReq request) async {
    try {
      emit(LoadingState(isLoading: true));
      final result = await leadGenerationUseCase.getMakeModel(request);
      emit(LoadingState(isLoading: false));
      result.fold((l) => emit(GetMakeModelFailureState(error: l)),
          (r) => emit(GetMakeModelSuccessState(response: r)));
    } catch (e) {
      emit(LoadingState(isLoading: false));
      emit(GetMakeModelFailureState(error: NoDataFailure()));
    }
  }

  void getDealers(GetDealerReq request) async {
    try {
      emit(LoadingState(isLoading: true));
      final result = await leadGenerationUseCase.getDealers(request);
      emit(LoadingState(isLoading: false));
      result.fold((l) => emit(GetDealersFailureState(error: l)),
          (r) => emit(GetDealersSuccessState(response: r)));
    } catch (e) {
      emit(LoadingState(isLoading: false));
      emit(GetDealersFailureState(error: NoDataFailure()));
    }
  }
}
