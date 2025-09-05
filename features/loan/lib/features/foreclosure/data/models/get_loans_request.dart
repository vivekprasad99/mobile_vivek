class GetLoansRequest {
  final String? ucic;

  GetLoansRequest({
    this.ucic,
  });

  factory GetLoansRequest.fromJson(Map<String, dynamic> json) =>
      GetLoansRequest(
        ucic: json["ucic"],
      );

  Map<String, dynamic> toJson() => {
        "ucic": ucic,
      };
}
