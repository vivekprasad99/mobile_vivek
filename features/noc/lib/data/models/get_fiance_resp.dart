class GetFinacerNamesResp {
  final String? code;
  final String? message;
  final List<FinancerName>? data;

  GetFinacerNamesResp({
    this.code,
    this.message,
    this.data,
  });

  factory GetFinacerNamesResp.fromJson(Map<String, dynamic> json) =>
      GetFinacerNamesResp(
        code: json["code"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<FinancerName>.from(
                json["data"]!.map((x) => FinancerName.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class FinancerName {
  final String? id;
  final String? financerName;

  FinancerName({
    this.id,
    this.financerName,
  });

  factory FinancerName.fromJson(Map<String, dynamic> json) => FinancerName(
        id: json["id"],
        financerName: json["financer_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "financer_name": financerName,
      };
}
