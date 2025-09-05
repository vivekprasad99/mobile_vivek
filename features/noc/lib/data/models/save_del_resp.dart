class SaveDeliveryResp {
    final String? code;
    final String? message;
    final String? responseCode;
    final SaveDeliveryData? data;

    SaveDeliveryResp({
        this.code,
        this.message,
        this.responseCode,
        this.data,
    });

    factory SaveDeliveryResp.fromJson(Map<String, dynamic> json) => SaveDeliveryResp(
        code: json["code"],
        message: json["message"],
        responseCode: json["responseCode"],
        data: json["data"] == null ? null : SaveDeliveryData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "responseCode": responseCode,
        "data": data?.toJson(),
    };
}

class SaveDeliveryData {
    final String? message;
    final String? code;

    SaveDeliveryData({
        this.message,
        this.code,
    });

    factory SaveDeliveryData.fromJson(Map<String, dynamic> json) => SaveDeliveryData(
        message: json["message"],
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "code": code,
    };
}
