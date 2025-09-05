class DedupeRequest {
  final String? mobileNumber;
  final  String? category;
  final String? subCategory;
  final String? productName;
  final bool? active;
  DedupeRequest({this.category, this.subCategory, this.productName, this.active, this.mobileNumber,} );

  factory DedupeRequest.fromJson(Map<String, dynamic> json) =>
      DedupeRequest(
        mobileNumber: json["mobileNumber"],
        category: json["category"],
        subCategory: json["subCategory"],
        productName: json["productName"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
    "mobileNumber": mobileNumber,
    "category": category,
    "subCategory": subCategory,
    "productName": productName,
    "active": active,
  };
}
