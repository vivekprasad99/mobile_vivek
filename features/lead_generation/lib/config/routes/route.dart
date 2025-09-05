enum Routes {
  leadGeneration("/leadGeneration/:leadType"),
  acknowledge("/acknowledge");

  const Routes(this.path);

  final String path;
}
