enum Routes {
  serviceRequest("/serviceRequest"),
  raiseRequest("/raiseRequest"),
  requestAcknowledgeScreen("/serviceRequestAcknowledgeScreen"),
  serviceUploadDocument("/serviceUploadDocument"),
  requestAcknowledgement("/requestAcknowledgement"),
  servicesTabScreen("/servicesTabScreen"),
  openServiceRequestScreen("/openServiceRequestScreen"),
  closeServiceRequestScreen("/closeServiceRequestScreen"),
  serviceRequestDetailScreen("/serviceRequestDetailScreen"),
  selectDetailsPage("/selectDetailsPage"),
  mandatesDetails("/mandatesDetails"),
  serviceTicketExist("/serviceRequestExist"),
  documentDetailsScreen("/documentDetailsScreen");

  const Routes(this.path);
  final String path;
}
