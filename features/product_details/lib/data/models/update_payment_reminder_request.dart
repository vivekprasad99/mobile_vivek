class UpdatePaymentReminderRequest {
  final String? loanId;
  final String? loanNumber;
  final String? ucic;
  final String? mobileNumber;
  final String? deviceId;
  final String? sourceSystem;
  final Reminder? reminder;

  UpdatePaymentReminderRequest({
    this.loanId,
    this.loanNumber,
    this.ucic,
    this.mobileNumber,
    this.deviceId,
    this.sourceSystem,
    this.reminder,
  });

  factory UpdatePaymentReminderRequest.fromJson(Map<String, dynamic> json) =>
      UpdatePaymentReminderRequest(
        loanId: json["loanId"],
        loanNumber: json["loanNumber"],
        ucic: json["ucic"],
        mobileNumber: json["mobileNumber"],
        deviceId: json["deviceId"],
        sourceSystem: json["sourceSystem"],
        reminder: json["reminder"] == null
            ? null
            : Reminder.fromJson(json["reminder"]),
      );

  Map<String, dynamic> toJson() => {
        "loanId": loanId,
        "loanNumber": loanNumber,
        "ucic": ucic,
        "mobileNumber": mobileNumber,
        "deviceId": deviceId,
        "sourceSystem": sourceSystem,
        "reminder": reminder?.toJson(),
      };
}

class Reminder {
  final String? reminderId;
  final String? reminderDurationType;
  final String? date;
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
        date: json["date"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "reminder_id": reminderId,
        "reminder_duration_type": reminderDurationType,
        "date": date,
        "time": time,
      };
}
