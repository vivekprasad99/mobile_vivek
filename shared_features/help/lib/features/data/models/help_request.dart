class HelpRequest {
  final String? category;
  final String? language;

  HelpRequest({
    this.category,
    this.language,
  });

  factory HelpRequest.fromJson(Map<String, dynamic> json) =>
      HelpRequest(
        category: json["category"],
        language: json["language"],
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "language": language,
      };
}
