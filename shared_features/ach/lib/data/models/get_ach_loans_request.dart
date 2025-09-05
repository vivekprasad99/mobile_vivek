class GetAchLoansRequest {
  final String? ucic;
  final String? filter;
  final bool? refundFlag;
  final String? currentTimeStamp;
  final String? superAppId;
  final String? source;

  GetAchLoansRequest({
    this.ucic,
    this.filter,
    this.refundFlag,
    this.currentTimeStamp,
    this.superAppId,
    this.source
  });

  factory GetAchLoansRequest.fromJson(Map<String, dynamic> json) =>
      GetAchLoansRequest(
        ucic: json["ucic"],
        filter: json["filter"],
        refundFlag: json["refundFlag"],
        currentTimeStamp: json["refundRequestDate"],
        superAppId: json["superAppId"],
        source: json["source"],
      );

  Map<String, dynamic> toJson() => {
        "ucic": ucic,
        "filter": filter,
        "refundRequestDate": currentTimeStamp,
        "refundFlag": refundFlag,
        "superAppId": superAppId,
        "source": source
      };
}
