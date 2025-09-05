class GetVahanDetailsResp {
  final String? code;
  final String? message;
  final VahanData? data;

  GetVahanDetailsResp({
    this.code,
    this.message,
    this.data,
  });

  factory GetVahanDetailsResp.fromJson(Map<String, dynamic> json) =>
      GetVahanDetailsResp(
        code: json["code"],
        message: json["message"],
        data: json["data"] == null ? null : VahanData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data?.toJson(),
      };
}

class VahanData {
  final String? customerNo;
  final String? chasisNo;
  final String? vehicleEngineNo;
  final String? financersName;

  VahanData({
    this.customerNo,
    this.chasisNo,
    this.vehicleEngineNo,
    this.financersName,
  });

  factory VahanData.fromJson(Map<String, dynamic> json) => VahanData(
        customerNo: json["customer_no"],
        chasisNo: json["chasis_no"],
        vehicleEngineNo: json["vehicle_engine_no"],
        financersName: json["financers_name"],
      );

  Map<String, dynamic> toJson() => {
        "customer_no": customerNo,
        "chasis_no": chasisNo,
        "vehicle_engine_no": vehicleEngineNo,
        "financers_name": financersName,
      };
}
