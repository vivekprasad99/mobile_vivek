class GreenChannelValidationResp {
  final String? code;
  final String? message;
  final String? responseCode;
  final GreenChannelData? data;

  GreenChannelValidationResp({
    this.code,
    this.message,
    this.responseCode,
    this.data,
  });

  factory GreenChannelValidationResp.fromJson(Map<String, dynamic> json) =>
      GreenChannelValidationResp(
        code: json["code"],
        message: json["message"],
        responseCode: json["responseCode"],
        data: json["data"] == null
            ? null
            : GreenChannelData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "responseCode": responseCode,
        "data": data?.toJson(),
      };
}

class GreenChannelData {
  final List<ErrorCode>? errorCodes;

  GreenChannelData({
    this.errorCodes,
  });

  factory GreenChannelData.fromJson(Map<String, dynamic> json) =>
      GreenChannelData(
        errorCodes: json["errorCodes"] == null
            ? []
            : List<ErrorCode>.from(
                json["errorCodes"]!.map((x) => ErrorCode.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "errorCodes": errorCodes == null
            ? []
            : List<dynamic>.from(errorCodes!.map((x) => x.toJson())),
      };
}

class ErrorCode {
  final String? errorCode;
  final String? errorMessage;

  ErrorCode({
    this.errorCode,
    this.errorMessage,
  });

  factory ErrorCode.fromJson(Map<String, dynamic> json) => ErrorCode(
        errorCode: json["errorCode"],
        errorMessage: json["errorMessage"],
      );

  Map<String, dynamic> toJson() => {
        "errorCode": errorCode,
        "errorMessage": errorMessage,
      };
}
