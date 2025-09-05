class NameMatchReq {
  final String? custName;
  final String? beneName;
  final String? superAppId;
  final String? source;

  NameMatchReq({
    this.custName,
    this.beneName,
    this.source,
    this.superAppId
  });

  factory NameMatchReq.fromJson(Map<String, dynamic> json) => NameMatchReq(
        custName: json["sourceName"],
        beneName: json["targetName"],
        source: json["source"],
        superAppId: json["superAppId"],
      );

  Map<String, dynamic> toJson() => {
        "sourceName": custName,
        "targetName": beneName,
        "source": source,
        "superAppId": superAppId,
      };
}
