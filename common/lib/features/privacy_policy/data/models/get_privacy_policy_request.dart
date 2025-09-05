class GetPrivacyPolicyRequest {
  final String? category;
  final String? language;

  GetPrivacyPolicyRequest({
    this.category,
    this.language,
  });

  factory GetPrivacyPolicyRequest.fromJson(Map<String, dynamic> json) =>
      GetPrivacyPolicyRequest(
        category: json["category"],
        language: json["language"],
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "language": language,
      };
}
