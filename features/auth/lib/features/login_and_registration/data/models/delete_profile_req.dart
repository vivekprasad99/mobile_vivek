class DeleteProfileReq {
  final String superAppId;
  final String source;

  DeleteProfileReq({
    required this.superAppId,
    required this.source,
  });

  factory DeleteProfileReq.fromJson(Map<String, dynamic> json) =>
      DeleteProfileReq(
        superAppId: json["superAppId"],
        source: json["source"],
      );

  Map<String, dynamic> toJson() => {
        "superAppId": superAppId,
        "source": source,
      };
}
