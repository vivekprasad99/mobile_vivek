class ServiceRequestItemModel {
  ServiceRequestItemModel(
      {this.serviceRequestN,
      this.lastUpdatedDate,
      this.inputtext1,
      this.inputtext2,
      this.product,
      this.subProduct,
      this.id}) {
    serviceRequestN = serviceRequestN ?? "Service request number";
    lastUpdatedDate = lastUpdatedDate ?? "Last Updated date";
    inputtext1 = inputtext1 ?? "6345243";
    inputtext2 = inputtext2 ?? "10 Aug’ 24 ";
    product = product ?? "Personal Loan";
    subProduct = subProduct ?? "10,000";
    id = id ?? "";
  }

  String? serviceRequestN;

  String? lastUpdatedDate;

  String? inputtext1;

  String? inputtext2;

  String? product;

  String? subProduct;

  String? id;
}
