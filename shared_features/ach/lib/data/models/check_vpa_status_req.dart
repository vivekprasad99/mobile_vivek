class CheckVpaStatusReq{
  final String? actionType;
  final String? trxnNo;
  final String? refNo;
  final String? superAppId;
  final String? source;

  CheckVpaStatusReq({
    this.actionType,
    this.trxnNo,
    this.refNo,
    this.superAppId,
    this.source
  });

  factory CheckVpaStatusReq.fromJson(Map<String, dynamic> json) =>
      CheckVpaStatusReq(
        actionType: json["actiontype"],
        trxnNo: json["trxnno"],
        refNo: json["refno"],
        superAppId: json["superAppId"],
        source: json["source"],
      );

  Map<String, dynamic> toJson() => {
    "actiontype": actionType,
    "trxnno": trxnNo,
    "refno": refNo,
    "superAppId": superAppId,
    "source": source,
  };
}