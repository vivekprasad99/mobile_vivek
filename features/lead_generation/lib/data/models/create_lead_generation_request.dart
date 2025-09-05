// ignore_for_file: public_member_api_docs, sort_constructors_first
class LeadGenerationRequest {
  String? name;
  String? leadType;
  String? pinCode;
  String? mobileNumber;
  String? state;
  String? city;
  String? subCategory;
  String? customerId;
  String? entityCode;
  String? assetCode;
  String? product;
  String? superAppId;
  LeadGenerationRequest(
      {this.name,
      this.leadType,
      this.pinCode,
      required this.mobileNumber,
      this.state,
      this.city,
      this.subCategory,
      required this.customerId,
      this.entityCode,
      this.assetCode,
      this.product,
      required this.superAppId,
      });

  LeadGenerationRequest.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    leadType = json['leadType'];
    pinCode = json['pinCode'];
    mobileNumber = json['mobileNumber'];
    state = json['state'];
    city = json['city'];
    subCategory = json['subCategory'];
    customerId = json['customerId'];
    entityCode = json['entityCode'];
    assetCode = json['assetCode'];
    product = json['product'];
    superAppId=json['superAppId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['leadType'] = leadType;
    data['pinCode'] = pinCode;
    data['mobileNumber'] = mobileNumber;
    data['state'] = state;
    data['city'] = city;
    data['subCategory'] = subCategory;
    data['customerId'] = customerId;
    data['entityCode'] = entityCode;
    data['assetCode'] = assetCode;
    data['product'] = product;
    data['superAppId']=superAppId;
    return data;
  }

  LeadGenerationRequest copyWith({
    String? name,
    String? leadType,
    String? pinCode,
    String? mobileNumber,
    String? state,
    String? city,
    String? subCategory,
    String? customerId,
    String? entityCode,
    String? assetCode,
    String? product,
    String? superAppId,
  }) {
    return LeadGenerationRequest(
      name: name ?? this.name,
      leadType: leadType ?? this.leadType,
      pinCode: pinCode ?? this.pinCode,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      state: state ?? this.state,
      city: city ?? this.city,
      subCategory: subCategory ?? this.subCategory,
      customerId: customerId ?? this.customerId,
      entityCode: entityCode ?? this.entityCode,
      assetCode: assetCode ?? this.assetCode,
      product: product ?? this.product,
      superAppId:superAppId??this.superAppId,
    );
  }
}
