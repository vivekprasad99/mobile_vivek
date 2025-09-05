class PaymentRemindersResponse {
  final String? loanId;
  final String? loanNumber;
  final String? sourceSystem;
  final String? nextDueDate;
  final String? status;
  final List<Reminder>? reminder;

  PaymentRemindersResponse({
    this.loanId,
    this.loanNumber,
    this.sourceSystem,
    this.nextDueDate,
    this.status,
    this.reminder,
  });

  factory PaymentRemindersResponse.fromJson(Map<String, dynamic> json) =>
      PaymentRemindersResponse(
        loanId: json["loanId"],
        loanNumber: json["loanNumber"],
        sourceSystem: json["sourceSystem"],
        nextDueDate: json["next_due_date"],
        status: json["status"],
        reminder: json["reminder"] == null
            ? []
            : List<Reminder>.from(
                json["reminder"]!.map((x) => Reminder.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "loanId": loanId,
        "loanNumber": loanNumber,
        "sourceSystem": sourceSystem,
        "next_due_date": nextDueDate,
        "status": status,
        "reminder": reminder == null
            ? []
            : List<dynamic>.from(reminder!.map((x) => x.toJson())),
      };
}

class Reminder {
  final String? reminderId;
  final String? reminderDurationType;
  final DateTime? date;
  final String? time;

  Reminder({
    this.reminderId,
    this.reminderDurationType,
    this.date,
    this.time,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
        reminderId: json["reminder_id"],
        reminderDurationType: json["reminder_duration_type"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "reminder_id": reminderId,
        "reminder_duration_type": reminderDurationType,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "time": time,
      };
}
