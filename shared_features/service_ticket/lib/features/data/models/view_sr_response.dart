class ViewSRResponse {
  String? code;
  String? message;
  String? responseCode;
  List<ServiceRequest>? data;

  ViewSRResponse({this.code, this.message, this.responseCode, this.data});

  ViewSRResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    responseCode = json['responseCode'];
    if (json['data'] != null) {
      data = <ServiceRequest>[];
      json['data'].forEach((v) {
        data!.add(ServiceRequest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['responseCode'] = responseCode;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceRequest {
  String? customerId;
  String? mobileNumber;
  String? caseNumber;
  String? lan;
  String? category;
  String? subCategory;
  String? productName;
  String? srStatus;
  String? refundStatus;
  String? srAction;
  String? caseCreatedAt;
  String? caseUpdatedAt;
  String? adjustment;
  String? nachhold;
  String? lob;
  String? sourceSystem;
  List<String>? feedbacks;

  ServiceRequest(
      {this.customerId,
      this.mobileNumber,
      this.caseNumber,
      this.lan,
      this.category,
      this.subCategory,
      this.productName,
      this.srStatus,
      this.refundStatus,
      this.srAction,
      this.caseCreatedAt,
      this.caseUpdatedAt,
      this.adjustment,
      this.nachhold,
      this.lob,
      this.sourceSystem,
      this.feedbacks});

  ServiceRequest.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    mobileNumber = json['mobileNumber'];
    caseNumber = json['caseNumber'];
    lan = json['loanNumber'];
    category = json['category'];
    subCategory = json['subCategory'];
    productName = json['productName'];
    srStatus = json['srStatus'];
    refundStatus = json['refundStatus'];
    srAction = json['srAction'];
    caseCreatedAt = json['caseCreatedAt'];
    caseUpdatedAt = json['caseUpdatedAt'];
    adjustment = json['adjustment'];
    nachhold = json['nachhold'];
    sourceSystem = json['sourceSystem'];
    lob = json['lob'];
    if (json['feedbacks'] != null) {
      feedbacks = <String>[];
      json['feedbacks'].forEach((v) {
        feedbacks!.add('');
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerId'] = customerId;
    data['mobileNumber'] = mobileNumber;
    data['caseNumber'] = caseNumber;
    data['loanNumber'] = lan;
    data['category'] = category;
    data['subCategory'] = subCategory;
    data['productName'] = productName;
    data['srStatus'] = srStatus;
    data['refundStatus'] = refundStatus;
    data['srAction'] = srAction;
    data['caseCreatedAt'] = caseCreatedAt;
    data['caseUpdatedAt'] = caseUpdatedAt;
    data['adjustment'] = adjustment;
    data['nachhold'] = nachhold;
    data['sourceSystem'] = sourceSystem;
    data['lob'] = lob;
    if (feedbacks != null) {
      data['feedbacks'] = feedbacks!.map((v) => v).toList();
    }
    return data;
  }
}
