class SaveBranchRequest {
  final String code;
  final bool saveBranch;
  final String superAppId;

  SaveBranchRequest({
    required this.code,
    required this.saveBranch,
    required this.superAppId,
  });

  SaveBranchRequest copyWith({
    String? code,
    bool? saveBranch,
    String? superAppId,
  }) =>
      SaveBranchRequest(
        code: code ?? this.code,
        saveBranch: saveBranch ?? this.saveBranch,
        superAppId: superAppId ?? this.superAppId,
      );

  factory SaveBranchRequest.fromJson(Map<String, dynamic> json) =>
      SaveBranchRequest(
        code: json["code"],
        saveBranch: json["saveBranch"],
        superAppId: json["superAppId"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "saveBranch": saveBranch,
        "superAppId": superAppId,
      };
}
