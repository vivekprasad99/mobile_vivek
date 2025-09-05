class DlNocReq {
  final String finReference;

  DlNocReq({
    required this.finReference,
  });

  factory DlNocReq.fromJson(Map<String, dynamic> json) => DlNocReq(
        finReference: json["finReference"],
      );

  Map<String, dynamic> toJson() => {
        "finReference": finReference,
      };
}
