enum Routes {
  nocDetails("/nocDetails"),
  nocLoanList("/nocLoanList"),
  rcList("/rcList"),
  visitBranch("/visitBranch"),
  serviceexists('/serviceexists'),
  servicerequestscreen("/servicerequestscreen"),
  deliverysuccess('/deliverysuccess'),
  somethingWentWrongScreen('/somethingWentWrongScreen');

  const Routes(this.path);

  final String path;
}
