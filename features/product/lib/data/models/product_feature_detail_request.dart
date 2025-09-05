class ProductFeatureDetailRequest {
  String? productType;
  String? productSubType;

  ProductFeatureDetailRequest({this.productSubType,this.productType});

  ProductFeatureDetailRequest.fromJson(Map<String, dynamic> json) {
    productType = json['product_type'];
    productSubType = json['product_sub_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_type'] = productType;
    data['product_sub_type'] = productSubType;
    return data;
  }
}