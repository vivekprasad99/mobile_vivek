import 'package:product_details/data/models/active_loan_list_response.dart';

class UpcomingPaymentViewModel {

  double getTotalPayableAmount(ActiveLoanData data) {
    double totalPayableAmount = 0.0;
    if ( (data.totalAmountOverdue ?? 0.0) > 0){
      totalPayableAmount = (data.totalAmountOverdue ?? 0.0);
    }else{
      totalPayableAmount = (data.installmentAmount ?? 0.0);
    }
    return totalPayableAmount;
  }
}
