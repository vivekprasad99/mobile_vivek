import 'package:ach/data/models/get_ach_loans_response.dart';
import 'package:core/config/string_resource/strings.dart';

import '../data/models/loan_refund_params/refund_status_type.dart';
import 'cubit/loan_refund_state.dart';

class LoanRefundViewModel {
  LoanData selectedLoan;
  List<LoanData> loans = [];

  LoanRefundViewModel({required this.selectedLoan, required this.loans});

  final double _minRefundCap = 1.0;
  bool _isAdjust = false;

  void setSelectedLoan(LoanData loanData) {
    selectedLoan = loanData;
  }

  void setLoanList(List<LoanData> list) {
    loans = list;
  }

  LoanRefundState refund({bool? forceAdjust}) {
    if (forceAdjust != null) {
      _isAdjust = forceAdjust;
    }

    if (selectedLoan.excessAmount! <= 0.0) {
      return NoRefund();
    }

    if (isThereADueWithLoans()) {
      return _getDuesScenario();
    } else {
      return _getNoDuesScenario();
    }
  }

  LoanRefundState _getDuesScenario() {
    if (_isScenarioNo8()) {
      return AdjustWithSR(
          srMessage:
              "_isScenarioNo8 : Adjust excess fund with other loan dues. ");
    } else if (_isScenarioNo9()) {
      return RefundAndAdjustWithPennyDropAndSR(
          srMessage:
              '_isScenarioNo9 : Adjust excess fund with other loan dues + Refund if EAD > INR X',
          refundAmountAfterAdjust:
              selectedLoan.excessAmount! - getTotalOverDueAmount(loans));
    } else if (_isScenarioNo10()) {
      return RefundWithCreateMandateAndSR(
          srMessage: 'create manadate and refund SR');
    } else if (_isScenarioNo11()) {
      return RefundAndAdjustWithCreateMandateAndSR(
          srMessage:
              "create mandate - Adjust excess fund with other loan dues + Refund if EAD > INR X ",
          refundAmountAfterAdjust:
              selectedLoan.excessAmount! - getTotalOverDueAmount(loans));
    } else if (_isScenarioNo12()) {
      return RefundAndAdjustWithPennyDropAndSR(
          srMessage:
              'Adjust excess fund with other loan dues + Refund if EAD> INR X',
          refundAmountAfterAdjust:
              selectedLoan.excessAmount! - getTotalOverDueAmount(loans));
    } else if (_isScenarioNo13()) {
      return RefundAndAdjustWithPennyDropAndSR(
          srMessage:
              'Adjust excess fund with other loan dues + Refund if EAD> INR X',
          refundAmountAfterAdjust:
              selectedLoan.excessAmount! - getTotalOverDueAmount(loans));
    } else if (_isScenarioNo14()) {
      return AdjustWithHoldACHSR(
          srMessage: "ACH hold + Adjust excess fund with other loan dues. ");
    } else if (_isScenarioNo15()) {
      return RefundAndAdjustWithPennyDropAndHoldACHSR(
          srMessage:
              'ACH hold + Adjust excess fund with other loan dues+ Refund. ',
          refundAmountAfterAdjust: selectedLoan.excessAmount! -
              (getTotalOverDueAmount(loans) + selectedLoan.installmentAmount!));
    } else {
      return RefundWithPennyDropAndSR(srMessage: "Unknown reason");
    }
  }

  LoanRefundState _getNoDuesScenario() {
    if (_isScenarioNo1()) {
      return RefundWithPennyDropAndSR(
          srMessage: "_isScenarioNo1 : ONLY Refund");
    } else if (_isScenarioNo2()) {
      return AdjustOnly(
          srMessage: "_isScenarioNo2 : Adjust only - Onscreen message");
    } else if (_isScenarioNo3()) {
      return RefundWithCreateMandateAndSR(
          srMessage: 'create manadate and refund SR');
    } else if (_isScenarioNo4() || _isScenarioNo5()) {
      return RefundWithPennyDropAndSR(
          srMessage: "_isScenarioNo4 : ONLY Refund");
    } else if (_isScenarioNo6()) {
      return AdjustWithHoldACHSR(
          srMessage: "_isScenarioNo6 : Create SR + ACH hold");
    } else if (_isScenarioNo7()) {
      return AdjustAndRefundWithPennyDropAndHoldACHSR(
          srMessage:
              "_isScenarioNo7 : Create SR for Refund SR and also do ACH hold",
          refundAmountAfterAdjust:
              selectedLoan.excessAmount! - selectedLoan.installmentAmount!);
    } else {
      return RefundWithPennyDropAndSR(srMessage: "Unknown reason");
    }
  }

  bool showUpcomingEMI() {
    return _isFutureEmiRemaining();
  }

  // selected loan scenarios conditions
  bool _isFutureEmiRemaining() {
    try {
      bool isFutureEmiRemaining =
          (selectedLoan.loanTenure ?? 0) - (selectedLoan.totalEmiPaid ?? 0) !=
              0;
      return isFutureEmiRemaining;
    } catch (e) {
      return true;
    }
  }

  bool _isEMandateAgainstLoan() {
    return selectedLoan.mandateStatus?.toLowerCase() == "active" ||
        selectedLoan.mandateStatus?.toLowerCase() == "inactive" ||
        selectedLoan.mandateStatus?.toLowerCase() == "hold";
  }

  bool _isExcessAmountMoreThanEmi() {
    try {
      return (selectedLoan.excessAmount ?? 0) >
          (selectedLoan.installmentAmount ?? 0);
    } catch (e) {
      return false;
    }
  }

  // other loan scenarios condition
  bool isThereADueWithLoans() {
    for (var loan in loans) {
      if (double.parse(loan.totalAmountOverdue!) > 0) {
        return true;
      }
    }
    return false;
  }

  bool _isSelectedLoanExcessAmountMoreThanLoanDues() {
    return selectedLoan.excessAmount! > getTotalOverDueAmount(loans);
  }

  bool isExcessAmountMoreThanOtherLoanDuesAndSelectedLoanEMI() {
    try {
      double totalOtherLoansDue = 0;
      for (var loan in loans) {
        totalOtherLoansDue += double.parse(loan.totalAmountOverdue!);
      }
      return (selectedLoan.excessAmount ?? 0) >
          (totalOtherLoansDue + (selectedLoan.installmentAmount ?? 0));
    } catch (e) {
      return false;
    }
  }

  bool isRefundMoreThanMinAmount(double refundAmount) {
    return refundAmount > _minRefundCap;
  }

  bool isAdjustmentApplicable(LoanData loan) {
    return loan.excessAmount! > loan.installmentAmount! && _isFutureEmiRemaining();
  }

  // Scenarios conditions
  bool _isScenarioNo1() {
    return !_isFutureEmiRemaining() && !_isEMandateAgainstLoan();
  }

  bool _isScenarioNo2() {
    return _isFutureEmiRemaining() && !_isEMandateAgainstLoan() && _isAdjust;
  }

  bool _isScenarioNo3() {
    return _isFutureEmiRemaining() && !_isEMandateAgainstLoan() && !_isAdjust;
  }

  bool _isScenarioNo4() {
    return _isFutureEmiRemaining() &&
        _isEMandateAgainstLoan() &&
        selectedLoan.excessAmount! < selectedLoan.installmentAmount!;
  }

  bool _isScenarioNo5() {
    return _isFutureEmiRemaining() &&
        _isEMandateAgainstLoan() &&
        selectedLoan.excessAmount! > selectedLoan.installmentAmount!;
  }

  bool _isScenarioNo6() {
    return _isFutureEmiRemaining() &&
        _isEMandateAgainstLoan() &&
        selectedLoan.excessAmount! > selectedLoan.installmentAmount! &&
        _isAdjust &&
        !isRefundMoreThanMinAmount(getRefundAmount());
  }

  bool _isScenarioNo7() {
    return _isFutureEmiRemaining() &&
        _isEMandateAgainstLoan() &&
        selectedLoan.excessAmount! > selectedLoan.installmentAmount! &&
        _isAdjust &&
        isRefundMoreThanMinAmount(getRefundAmount());
  }

  bool _isScenarioNo8() {
    return isThereADueWithLoans() &&
        !_isSelectedLoanExcessAmountMoreThanLoanDues();
  }

  bool _isScenarioNo9() {
    return isThereADueWithLoans() &&
        _isSelectedLoanExcessAmountMoreThanLoanDues() &&
        !_isFutureEmiRemaining();
  }

  bool _isScenarioNo10() {
    return isThereADueWithLoans() &&
        _isSelectedLoanExcessAmountMoreThanLoanDues() &&
        _isFutureEmiRemaining() &&
        !_isEMandateAgainstLoan() &&
        !_isAdjust;
  }

  bool _isScenarioNo11() {
    return isThereADueWithLoans() &&
        _isSelectedLoanExcessAmountMoreThanLoanDues() &&
        _isFutureEmiRemaining() &&
        !_isEMandateAgainstLoan() &&
        _isAdjust;
  }

  bool _isScenarioNo12() {
    return isThereADueWithLoans() &&
        _isSelectedLoanExcessAmountMoreThanLoanDues() &&
        _isFutureEmiRemaining() &&
        !_isExcessAmountMoreThanEmi() &&
        _isEMandateAgainstLoan() &&
        isRefundMoreThanMinAmount(
            selectedLoan.excessAmount! - getTotalOverDueAmount(loans));
  }

  bool _isScenarioNo13() {
    return isThereADueWithLoans() &&
        _isSelectedLoanExcessAmountMoreThanLoanDues() &&
        _isFutureEmiRemaining() &&
        _isExcessAmountMoreThanEmi() &&
        _isEMandateAgainstLoan() &&
        isRefundMoreThanMinAmount(
            selectedLoan.excessAmount! - getTotalOverDueAmount(loans));
  }

  bool _isScenarioNo14() {
    return isThereADueWithLoans() &&
        _isSelectedLoanExcessAmountMoreThanLoanDues() &&
        _isFutureEmiRemaining() &&
        _isExcessAmountMoreThanEmi() &&
        _isEMandateAgainstLoan() &&
        _isAdjust &&
        !isRefundMoreThanMinAmount(
            selectedLoan.excessAmount! - getTotalOverDueAmount(loans));
  }

  bool _isScenarioNo15() {
    return isThereADueWithLoans() &&
        _isSelectedLoanExcessAmountMoreThanLoanDues() &&
        _isFutureEmiRemaining() &&
        _isExcessAmountMoreThanEmi() &&
        _isEMandateAgainstLoan() &&
        _isAdjust &&
        !isRefundMoreThanMinAmount(
            selectedLoan.excessAmount! - getTotalOverDueAmount(loans));
  }

  bool isExcessAmount() {
    return selectedLoan.excessAmount! > 0.0;
  }

  bool isRefundApplicable() {
    return _isSelectedLoanExcessAmountMoreThanLoanDues();
  }

  bool isRefundOrAdjustAnythingApplicable() {
    return selectedLoan.excessAmount! > 0.0;
  }

  static double getTotalOverDueAmount(List<LoanData>? loanList) {
    double? total = loanList?.fold(
        0,
        (double? sum, item) =>
            (sum ?? 0.0) + (double.parse(item.totalAmountOverdue ?? "")));
    return total ?? 0.0;
  }

  RefundStatus getRefundStatus() {
    return RefundStatus(
        selectedLoan: selectedLoan,
        loanList: loans,
        isRefundApplicable: _isSelectedLoanExcessAmountMoreThanLoanDues(),
        refundAmount: selectedLoan.excessAmount! - getTotalOverDueAmount(loans),
        isDues: _isSelectedLoanExcessAmountMoreThanLoanDues());
  }

  getRefundAmount() {
    if (isRefundApplicable()) {
      return selectedLoan.excessAmount! - getTotalOverDueAmount(loans);
    }
    return 0.0;
  }

  getRefundType(LoanRefundState? state) {
    if (state is AdjustWithSR) {
      return RefundStatusType.adjustment.value;
    } else if (state is RefundWithPennyDropAndSR) {
      return RefundStatusType.refund.value;
    } else if (state is AdjustWithHoldACHSR) {
      return '${RefundStatusType.adjustment.value},${RefundStatusType.nachHold.value}';
    } else if (state is AdjustAndRefundWithPennyDropAndHoldACHSR) {
      return '${RefundStatusType.adjustment.value},${RefundStatusType.refund.value},${RefundStatusType.nachHold.value}';
    } else if (state is RefundAndAdjustWithPennyDropAndSR) {
      return '${RefundStatusType.refund.value},${RefundStatusType.adjustment.value}';
    } else if (state is RefundWithCreateMandateAndSR) {
      return RefundStatusType.refund.value;
    } else if (state is RefundAndAdjustWithPennyDropAndHoldACHSR) {
      return '${RefundStatusType.adjustment.value},${RefundStatusType.refund.value},${RefundStatusType.nachHold.value}';
    } else if (state is RefundAndAdjustWithCreateMandateAndSR) {
      return '${RefundStatusType.refund.value},${RefundStatusType.adjustment.value}';
    } else {
      return '';
    }
  }

  String getSrMessage(LoanRefundState? state) {
    if (state is AdjustOnly) {
      return state.srMessage;
    } else if (state is AdjustWithSR) {
      return state.srMessage;
    } else if (state is RefundWithPennyDropAndSR) {
      return state.srMessage;
    } else if (state is AdjustWithHoldACHSR) {
      return state.srMessage;
    } else if (state is AdjustAndRefundWithPennyDropAndHoldACHSR) {
      return state.srMessage;
    } else if (state is RefundAndAdjustWithPennyDropAndSR) {
      return state.srMessage;
    } else if (state is RefundWithCreateMandateAndSR) {
      return state.srMessage;
    } else if (state is RefundAndAdjustWithPennyDropAndHoldACHSR) {
      return state.srMessage;
    } else if (state is RefundAndAdjustWithCreateMandateAndSR) {
      return state.srMessage;
    } else {
      return '';
    }
  }

  String getAdjustLabelName(List<LoanData> loanList, LoanData loanData) {
    loans = loanList;
    selectedLoan = loanData;
    if (_isFutureEmiRemaining() &&
        _isEMandateAgainstLoan() &&
        selectedLoan.excessAmount! > selectedLoan.installmentAmount! &&
        isRefundMoreThanMinAmount(getRefundAmount())) {
      return lblAdjustPartialRefund;
    }
    return lblrefundAdjustFund;
  }
}

class RefundStatus {
  RefundStatus(
      {required this.selectedLoan,
      required this.loanList,
      required this.isRefundApplicable,
      required this.refundAmount,
      required this.isDues});

  final LoanData selectedLoan;
  final List<LoanData> loanList;
  final bool isRefundApplicable;
  final double refundAmount;
  final bool isDues;
}
