class GetMakeModelResp {
  final String? code;
  final String? message;
  final String? responseCode;
  final List<MakeModelData>? data;

  GetMakeModelResp({
    this.code,
    this.message,
    this.responseCode,
    this.data,
  });

  factory GetMakeModelResp.fromJson(Map<String, dynamic> json) =>
      GetMakeModelResp(
        code: json["code"],
        message: json["message"],
        responseCode: json["responseCode"],
        data: json["assetDetailsList"] == null
            ? []
            : List<MakeModelData>.from(json["assetDetailsList"]!
                .map((x) => MakeModelData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "responseCode": responseCode,
        "assetDetailsList": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class MakeModelData {
  final String? assetClass;
  final int? assetCode;
  final String? assetName;

  MakeModelData({
    this.assetClass,
    this.assetCode,
    this.assetName,
  });

  factory MakeModelData.fromJson(Map<String, dynamic> json) => MakeModelData(
        assetClass: json["assetClass"],
        assetCode: json["assetCode"],
        assetName: json["assetName"],
      );

  Map<String, dynamic> toJson() => {
        "assetClass": assetClass,
        "assetCode": assetCode,
        "assetName": assetName,
      };
}
