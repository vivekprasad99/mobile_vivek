class GetDealerResp {
  final String? code;
  final String? message;
  final String? responseCode;
  final List<DealersData>? data;

  GetDealerResp({
    this.code,
    this.message,
    this.responseCode,
    this.data,
  });

  factory GetDealerResp.fromJson(Map<String, dynamic> json) => GetDealerResp(
        code: json["code"],
        message: json["message"],
        responseCode: json["responseCode"],
        data: json["dealerList"] == null
            ? []
            : List<DealersData>.from(
                json["dealerList"]!.map((x) => DealersData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "responseCode": responseCode,
        "dealerList": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DealersData {
  final String? dealerCode;
  final String? dealerName;

  DealersData({
    this.dealerCode,
    this.dealerName,
  });

  factory DealersData.fromJson(Map<String, dynamic> json) => DealersData(
        dealerCode: json["dealerCode"],
        dealerName: json["dealerName"],
      );

  Map<String, dynamic> toJson() => {
        "dealerCode": dealerCode,
        "dealerName": dealerName,
      };
}
