// ignore_for_file: public_member_api_docs, sort_constructors_first
class RcAttempt {
  final String loanNumber;
  final int attempts;

  RcAttempt({
    required this.loanNumber,
    required this.attempts,
  });

  factory RcAttempt.fromJson(Map<String, dynamic> json) => RcAttempt(
        loanNumber: json["loanNumber"],
        attempts: json["attempts"],
      );

  Map<String, dynamic> toJson() => {
        "loanNumber": loanNumber,
        "attempts": attempts,
      };

  RcAttempt copyWith({
    String? loanNumber,
    int? attempts,
  }) {
    return RcAttempt(
      loanNumber: loanNumber ?? this.loanNumber,
      attempts: attempts ?? this.attempts,
    );
  }
}
