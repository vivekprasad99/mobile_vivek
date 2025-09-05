enum Routes {
  loansList("/foreclosure/loansList"),
  foreclosureDetail("/foreclosure/foreclosureDetails"),
  foreclosureChargesBottomSheet("/foreclosure/foreclosureChargesBottomSheet"),
  freezingPeriodBottomSheet("/foreclosure/freezingPeriodBottomSheet"),
  achloansList("/foreclosure/achloansList"),
  addedBanksScreen('/ach/addedBanksScreen'),
  selectBankScreen('/ach/selectBankScreen'),
  enterBankDetailsScreen('/ach/enterBankDetailsScreen'),

  mandateSuccessScreen('/ach/mandateSuccessScreen'),
  nameMismatchScreen('/ach/nameMismatchScreen'),
  serviceReqScreen('/ach/serviceReqScreen'),
  uploadDocumentScreen('/ach/uploadDocumentScreen'),
  upiScreen('/ach/upiScreen'),
  awaitingUpi('/ach/awaitingUpi'),
  bankVerifyOptions('/ach/bankVerifyOptions'),
  mandateDetailsScreen('/ach/mandateDetailsScreen'),
  cancelMadateScreen('/ach/cancelMadateScreen'),
  updateMadateScreen('/ach/updateMadateScreen'),
  loanCancelList("/loan_cancellation/loanCancelList"),
  loanCancelDetailScreen("/loan_cancellation/loanCancelDetailScreen"),
  loanCancelFailureScreen(
      "/loan_cancellation/loanCancelFailureScreen/:isNotPl/:isNotFlp"),
  loanCancelServiceTicketScreen(
      "/loan_cancellation/loanCancelServiceTicketScreen"),
  loanCancelPaymentOverviewScreen(
      "/loan_cancellation/loanCancelPaymentOverviewScreen"),
  loanCancelOffersScreen("/loan_cancellation/loanCancelOffersScreen"),

  //foreclosurePaymentOptions("/foreclosure/foreclosurePaymentOptions"),

  foreclosurePaymentSuccessScreen(
      "/foreclosure/foreClosurePaymentSuccessScreen"),

  requestAcknowledgedScreen("/foreclosure/requestAcknowledgeScreen");

  const Routes(this.path);
  final String path;
}
