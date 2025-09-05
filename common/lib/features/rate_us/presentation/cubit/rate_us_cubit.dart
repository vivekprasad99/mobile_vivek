import 'package:common/features/rate_us/data/models/rate_us_model.dart';
import 'package:common/features/rate_us/data/models/rate_us_request.dart';
import 'package:common/features/rate_us/data/models/rate_us_response.dart';
import 'package:common/features/rate_us/data/models/update_rate_us_request.dart';
import 'package:common/features/rate_us/data/models/update_rate_us_response.dart';
import 'package:common/features/rate_us/domain/usecases/rate_us_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:core/config/error/failure.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'rate_us_state.dart';

class RateUsCubit extends Cubit<RateUsState> {
  final RateUsUseCase usecase;

  RateUsCubit({required this.usecase}) : super(RateUsInitial()) {
    initiateRateUsList();
  }

  void updateRateUs(int index) {
    emit(EmptyRateUsState());
    List<RateUsModel> newRateUsList = rateUsList;
    for (RateUsModel name in newRateUsList) {
      name.isSelected = false;
    }
    if (!newRateUsList[index].isSelected) {
      newRateUsList[index].isSelected = true;
      emit(ChangeRateUsState(rateUsModelList: newRateUsList));
    }
  }

  void initiateRateUsList() {
    clearRateUsList();
  }

  void clearRateUsList() {
    emit(EmptyRateUsState());
    List<RateUsModel> newRateUsList = rateUsList;
    for (RateUsModel name in newRateUsList) {
      name.isSelected = false;
    }
    emit(ChangeRateUsState(rateUsModelList: newRateUsList));
  }

  void getRateUsModel(RateUsModel rateUsModel) {
    emit(GetRateUsModel(rateUsModel: rateUsModel));
  }

  void getRateUs(RateUsRequest request) async {
    try {
      emit(LoadingState(isloading: true));
      await Future.delayed(const Duration(seconds: 1));
      final result = await usecase.call(request);
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(RateUsFailureState(failure: l)),
              (r) => emit(RateUsSuccessState(response: r)),);
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(RateUsFailureState(failure: NoDataFailure()));
    }
  }

  Future<void> updateRateUsRecord(UpdateRateUsRequest rateUsRequest,bool? isComingFromCloseButton,bool isCustomerHappy) async {
    try {
      if (isComingFromCloseButton ?? false) {
        final result = await usecase.updateRateUsRecord(rateUsRequest);
        result.fold((l) => emit(RateUsFailureState(failure: l)),
                (r) =>
                emit(UpdateRateUsRecordSuccessState(response: r,
                    isComingFromCloseButton: isComingFromCloseButton,),),);
      } else {
        emit(LoadingState(isloading: true));
        await Future.delayed(const Duration(seconds: 3));
        final result = await usecase.updateRateUsRecord(rateUsRequest);
        emit(LoadingState(isloading: false));
        result.fold((l) => emit(RateUsFailureState(failure: l)),
                (r) =>
                emit(UpdateRateUsRecordSuccessState(response: r,
                    isComingFromCloseButton: isComingFromCloseButton,isCustomerHappy: isCustomerHappy,),),);
      }
    }
    catch (e) {
      emit(LoadingState(isloading: false));
      emit(RateUsFailureState(failure: NoDataFailure()));
    }
  }
}
