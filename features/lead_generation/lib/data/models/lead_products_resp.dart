class LeadProductsResp {
  final String? status;
  final int? code;
  final String? message;
  final List<LeadProductsData>? data;

  LeadProductsResp({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  factory LeadProductsResp.fromJson(Map<String, dynamic> json) =>
      LeadProductsResp(
        status: json["status"],
        code: json["code"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<LeadProductsData>.from(
                json["data"]!.map((x) => LeadProductsData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class LeadProductsData {
  final String? lob;
  final String? productName;
  final String? productValue;

  LeadProductsData({
    this.lob,
    this.productName,
    this.productValue,
  });

  factory LeadProductsData.fromJson(Map<String, dynamic> json) =>
      LeadProductsData(
        lob: json["lob"],
        productName: json["product_name"],
        productValue: json["product_value"],
      );

  Map<String, dynamic> toJson() => {
        "lob": lob,
        "product_name": productName,
        "product_value": productValue,
      };
}
