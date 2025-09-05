// singleton
class ConstantAssets {
  ConstantAssets._();

  static ConstantAssets get = ConstantAssets._();
  static const String svgPath = 'assets/images/svg/';
  static const String svgNoSearch = "assets/images/svg/no_search.svg";
}
