import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/service_request_item_model.dart';
import 'close_service_request_state.dart';

class CloseServiceRequestCubit extends Cubit<CloseServiceRequestState> {
  CloseServiceRequestCubit() : super(CloseServiceRequestStateInitial()) {
    listOpenServiceRequest();
  }

  void listOpenServiceRequest() {
    emit(CloseServiceRequestListState(listItem: [
      ServiceRequestItemModel(
          serviceRequestN: "Service request number",
          lastUpdatedDate: "Last Updated date",
          inputtext1: "6345243",
          inputtext2: "10 Aug’ 24 ",
          product: "Product : Loan",
          subProduct: "Sub Product : Personal Loan"),
      ServiceRequestItemModel(
          product: "Product : Loan", subProduct: "Sub Product : Personal Loan"),
      ServiceRequestItemModel(
          product: "Product : Loan", subProduct: "Sub Product : Personal Loan"),
      ServiceRequestItemModel(
          product: "Product : Loan", subProduct: "Sub Product : Personal Loan")
    ]));
  }
}
