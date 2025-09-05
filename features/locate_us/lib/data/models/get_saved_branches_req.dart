class GetSavedBranchesReq {
  final String superAppId;

  GetSavedBranchesReq({
    required this.superAppId,
  });

  GetSavedBranchesReq copyWith({
    String? superAppId,
  }) =>
      GetSavedBranchesReq(
        superAppId: superAppId ?? this.superAppId,
      );

  factory GetSavedBranchesReq.fromJson(Map<String, dynamic> json) =>
      GetSavedBranchesReq(
        superAppId: json["superAppId"],
      );

  Map<String, dynamic> toJson() => {
        "superAppId": superAppId,
      };
}
