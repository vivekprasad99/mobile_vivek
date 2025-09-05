enum Routes {
  loanRefund("/loan_refund"),
  raiseRefund("/raise_refund"),
  navigateToLoanRefundBankDetails("/loan_refund/LoanRefundBankDetails"),
  navigateToRefundPreview("/loan_refund/LoanRefundPreview"),
  navigateToLoanRefundServiceRequestSuccess(
      "/loan_refund/LoanRefundServiceRequestSuccess"),
  navigateToLoanRefundRaiseQuery("/loan_refund/LoanRefundRaiseQuery"),
  navigateToRequestAcknowledgedScreen("/foreclosure/requestAcknowledgeScreen"),
  navigateToAchloansListfromSR("/ach/achloansList"),
  navigateToServiceReqScreens('/ach/serviceReqScreen'),
  serviceReqScreen('/ach/serviceReqScreen'),
  adjustPreviewScreen("/loan_refund/LoanRefundAdjustLoan");
  const Routes(this.path);

  final String path;
}
