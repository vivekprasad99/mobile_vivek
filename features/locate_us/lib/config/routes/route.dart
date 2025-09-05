enum Routes {
  locateUsSearch('/locate_us/search'),
  locateUsBranches('/locate_us/branches'),
  locateUsMap('/locate_us/map'),
  ;

  const Routes(this.path);
  final String path;
}
