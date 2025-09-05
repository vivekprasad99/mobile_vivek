enum Routes {
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
  navigateTLoanRefundPreview('/loan_refund/LoanRefundPreview'),
  navigateTLoanRefundAdjustFundPreview('/loan_refund/LoanRefundAdjust'),
  updateCusBankDetail('/ach/updateCusBankDetail');
  const Routes(this.path);
  final String path;
}
