enum Routes {
  productsLoanListPage('/product_details/active_loans_tabs'),
  productsLoanDetailPage('/product_details/active_loans_detail'),
  productsPaymentsDetailPage('/product_details/productsPaymentsDetailPage'),
  openBottomSheetPage('/product_details/setReminderBottomSheet'),
  generateSoaDocWebView('/product_details/generateSoaDocWebView'),
  activeProductsLoanListPage('/product_details/active_loans_page'),
  completedProductsLoanListPage('/product_details/completed_loans_page');

  const Routes(this.path);

  final String path;
}
