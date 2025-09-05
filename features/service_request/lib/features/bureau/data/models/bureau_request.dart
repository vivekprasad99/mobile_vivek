class BureauRequest {
  final String? category;
  final String? language;

  BureauRequest({
    this.category,
    this.language,
  });

  factory BureauRequest.fromJson(Map<String, dynamic> json) =>
      BureauRequest(
        category: json["category"],
        language: json["language"],
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "language": language,
      };
}
