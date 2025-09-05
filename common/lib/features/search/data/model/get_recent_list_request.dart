class GetRecentListRequest {
  final String? superAppId;

  GetRecentListRequest({
    this.superAppId,
  });

  factory GetRecentListRequest.fromJson(Map<String, dynamic> json) =>
      GetRecentListRequest(
        superAppId: json["superAppId"],
      );

  Map<String, dynamic> toJson() => {
        "superAppId": superAppId,
      };
}