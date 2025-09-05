import 'package:core/config/error/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:lead_generation/data/models/get_dealer_resp.dart';
import 'package:lead_generation/data/models/get_make_model_resp.dart';
import 'package:lead_generation/data/models/get_state_city_resp.dart';
import 'package:lead_generation/data/models/lead_dealership_resp.dart';
import 'package:lead_generation/data/models/lead_products_resp.dart';

import '../../data/models/create_lead_generation_response.dart';
import '../../data/models/fetch_make_list_response.dart';
import '../../data/models/fetch_model_list_response.dart';

abstract class LeadGenerationState extends Equatable {}

class LeadGenerationInitial extends LeadGenerationState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends LeadGenerationState {
  final bool isLoading;
  LoadingState({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}

class LeadGenerationSuccessState extends LeadGenerationState {
  final CreateLeadGenerationResponse response;
  LeadGenerationSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class LeadGenerationFailureState extends LeadGenerationState {
  final Failure error;
  LeadGenerationFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

class ValidateState extends LeadGenerationState {
  final bool isValid;
  ValidateState({required this.isValid});

  @override
  List<Object?> get props => [isValid];
}

class PopulateStateCityState extends LeadGenerationState {
  final String city;
  final String state;

  PopulateStateCityState({required this.city, required this.state});

  @override
  List<Object?> get props => [city, state];
}

class FetchPinCodeSuccessState extends LeadGenerationState {
  final GetStateCityResp response;
  FetchPinCodeSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class FetchPinCodeFailureState extends LeadGenerationState {
  final Failure error;
  FetchPinCodeFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

class FetchMakeListSuccessState extends LeadGenerationState {
  final FetchMakeListResponse response;
  FetchMakeListSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class FetchMakeListFailureState extends LeadGenerationState {
  final Failure error;
  FetchMakeListFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

class FetchModelListSuccessState extends LeadGenerationState {
  final FetchModelListResponse response;
  FetchModelListSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class FetchModelListFailureState extends LeadGenerationState {
  final Failure error;
  FetchModelListFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

class FetchDealershipListSuccessState extends LeadGenerationState {
  final LeadVehicleDealerResp response;
  FetchDealershipListSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class FetchDealershipListFailureState extends LeadGenerationState {
  final Failure error;
  FetchDealershipListFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

class FetchInsuranceProductsSuccessState extends LeadGenerationState {
  final LeadProductsResp response;

  FetchInsuranceProductsSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class FetchInsuranceProductsFailureState extends LeadGenerationState {
  final Failure error;

  FetchInsuranceProductsFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

class SelectMakeModelState extends LeadGenerationState {
  final MakeModelData? makeModel;
  SelectMakeModelState({
    required this.makeModel,
  });
  @override
  List<Object?> get props => [makeModel];
}

class SelectDealerShipState extends LeadGenerationState {
  final DealersData? dealer;
  SelectDealerShipState({
    required this.dealer,
  });
  @override
  List<Object?> get props => [dealer];
}

class GetMakeModelSuccessState extends LeadGenerationState {
  final GetMakeModelResp response;
  GetMakeModelSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class GetMakeModelFailureState extends LeadGenerationState {
  final Failure error;
  GetMakeModelFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

class GetDealersSuccessState extends LeadGenerationState {
  final GetDealerResp response;

  GetDealersSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class GetDealersFailureState extends LeadGenerationState {
  final Failure error;

  GetDealersFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}
