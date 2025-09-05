enum Routes {
  // productFeatureLoanDetail("/product/productFeatureDetail");

  productFeaturesThreePage('/product/product_features_three_page'),
  productFeaturesOnePage('/product/product_features_one_page'),
  productFeaturesOneTabContainerScreen(
      '/product/product_features_one_tab_container_screen'),
  productsPage('/product/products_page'),
  sproductsTabContainerPage('/product/products_tab_container_page'),
  productsContainerScreen('/product/products_container_screen'),
  fullViewProductFeaturesPage('/product/full_view_product_features_page'),
  appNavigationScreen('/product/app_navigation_screen');

  const Routes(this.path);

  final String path;
}
