class DeDupeRequest {
  String? mobileNumber;
  String? category;
  String? subCategory;
  String? productName;
  bool? active;

  DeDupeRequest({this.mobileNumber, this.category, this.subCategory, this.productName, this.active});

  DeDupeRequest.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['mobileNumber'];
    category = json['category'];
    subCategory = json['subCategory'];
    productName = json['productName'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobileNumber'] = mobileNumber;
    data['category'] = category;
    data['subCategory'] = subCategory;
    data['productName'] = productName;
    data['active'] = active;
    return data;
  }
}
