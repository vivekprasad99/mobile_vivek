class ValidateVpaReq {
  final String? vpa;
  final String? superAppId;
  final String? source;

  ValidateVpaReq({
    required this.vpa,
    required this.superAppId,
    required this.source,
  });

  factory ValidateVpaReq.fromJson(Map<String, dynamic> json) => ValidateVpaReq(
        vpa: json["vpa"],
        superAppId: json["superAppId"],
        source: json["source"],
      );

  Map<String, dynamic> toJson() => {
        "vpa": vpa,
        "superAppId": superAppId,
        "source": source,
      };
}
