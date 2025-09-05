class FAQRequest {
  final String? category;
  final String? language;

  FAQRequest({
    this.category,
    this.language,
  });

  factory FAQRequest.fromJson(Map<String, dynamic> json) =>
      FAQRequest(
        category: json["category"],
        language: json["language"],
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "language": language,
      };
}
