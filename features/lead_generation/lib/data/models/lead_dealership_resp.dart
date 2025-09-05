class LeadVehicleDealerResp {
  final String? status;
  final String? message;
  final List<DealrData>? data;

  LeadVehicleDealerResp({
    this.status,
    this.message,
    this.data,
  });

  factory LeadVehicleDealerResp.fromJson(Map<String, dynamic> json) =>
      LeadVehicleDealerResp(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<DealrData>.from(
                json["data"]!.map((x) => DealrData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DealrData {
  final String? assetCode;
  final String? desc;
  final String? dealerCode;
  final String? dealerName;
  final String? currCost;
  final String? pincode;
  final String? location;

  DealrData({
    this.assetCode,
    this.desc,
    this.dealerCode,
    this.dealerName,
    this.currCost,
    this.pincode,
    this.location,
  });

  factory DealrData.fromJson(Map<String, dynamic> json) => DealrData(
        assetCode: json["asset_code"],
        desc: json["desc"],
        dealerCode: json["dealer_code"],
        dealerName: json["dealer_name"],
        currCost: json["curr_cost"],
        pincode: json["pincode"],
        location: json["location"],
      );

  Map<String, dynamic> toJson() => {
        "asset_code": assetCode,
        "desc": desc,
        "dealer_code": dealerCode,
        "dealer_name": dealerName,
        "curr_cost": currCost,
        "pincode": pincode,
        "location": location,
      };
}
