import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/service_request_item_model.dart';
import 'open_service_request_state.dart';

class OpenServiceRequestCubit extends Cubit<OpenServiceRequestState> {
  OpenServiceRequestCubit() : super(OpenServiceRequestStateInitial()) {
    listOpenServiceList();
  }

  listOpenServiceList() {
    emit(OpenServiceRequestListState(listItem: [
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
