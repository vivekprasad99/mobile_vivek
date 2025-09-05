class DeletePaymentReminderRequest {
  final String? loanId;
  final String? loanNumber;
  final String? ucic;
  final String? sourceSystem;
  final String? reminderId;

  DeletePaymentReminderRequest({
    this.loanId,
    this.loanNumber,
    this.ucic,
    this.sourceSystem,
    this.reminderId,
  });

  factory DeletePaymentReminderRequest.fromJson(Map<String, dynamic> json) => DeletePaymentReminderRequest(
    loanId: json["loanId"],
    loanNumber: json["loanNumber"],
    ucic: json["ucic"],
    sourceSystem: json["sourceSystem"],
    reminderId: json["reminder_id"],
  );

  Map<String, dynamic> toJson() => {
    "loanId": loanId,
    "loanNumber": loanNumber,
    "ucic": ucic,
    "sourceSystem": sourceSystem,
    "reminder_id": reminderId,
  };
}
