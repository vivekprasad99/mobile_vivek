enum Routes {
  serviceRequest("/serviceRequest"),
  requestAcknowledgeScreen("/serviceRequestAcknowledgeScreen"),
  serviceUploadDocument("/serviceUploadDocument"),
  requestAcknowledgement("/requestAcknowledgement"),
  servicesTabScreen("/servicesTabScreen"),
  openServiceRequestScreen("/openServiceRequestScreen"),
  closeServiceRequestScreen("/closeServiceRequestScreen"),
  selectDetailsPage("/selectDetailsPage"),
  mandatesDetails("/mandatesDetails"),
  serviceRequestSuccess("/serviceRequestSuccess"),
  navigateToAchloansList("/ach/achloansList"),
  serviceRequestExist("/serviceRequestExist"),

  //Bureau Screens
  bureau("/bureau_screen"),
  serviceRequestBureauRaised("/serviceRequestBureauRaised"),
  serviceRequestBureauExist("/serviceRequestBureauExist"),
  serviceBureauUploadDocuments("/serviceUploadDocuments"),
  uploadDocScreen("/uploadDocScreen"),
  newUploadDocScreen("/newUploadDocScreen");

  const Routes(this.path);
  final String path;
}
