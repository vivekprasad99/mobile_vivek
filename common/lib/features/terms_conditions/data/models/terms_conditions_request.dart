class TermsConditionsRequest {
  final String? category;
  final String? language;

  TermsConditionsRequest({
    this.category,
    this.language,
  });

  factory TermsConditionsRequest.fromJson(Map<String, dynamic> json) =>
      TermsConditionsRequest(
        category: json["category"],
        language: json["language"],
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "language": language,
      };
}
