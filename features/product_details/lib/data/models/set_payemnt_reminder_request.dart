class SetPaymentReminderRequest {
  final String? loanId;
  final String? loanNumber;
  final String? ucic;
  final String? mobileNumber;
  final String? deviceId;
  final String? sourceSystem;
  final List<Reminders>? reminder;

  SetPaymentReminderRequest({
    this.loanId,
    this.loanNumber,
    this.ucic,
    this.mobileNumber,
    this.deviceId,
    this.sourceSystem,
    this.reminder,
  });

  factory SetPaymentReminderRequest.fromJson(Map<String, dynamic> json) =>
      SetPaymentReminderRequest(
        loanId: json["loanId"],
        loanNumber: json["loanNumber"],
        ucic: json["ucic"],
        mobileNumber: json["mobileNumber"],
        deviceId: json["deviceId"],
        sourceSystem: json["sourceSystem"],
        reminder: json["reminder"] == null
            ? []
            : List<Reminders>.from(
                json["reminder"]!.map((x) => Reminders.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "loanId": loanId,
        "loanNumber": loanNumber,
        "ucic": ucic,
        "mobileNumber": mobileNumber,
        "deviceId": deviceId,
        "sourceSystem": sourceSystem,
        "reminder": reminder == null
            ? []
            : List<dynamic>.from(reminder!.map((x) => x.toJson())),
      };
}

class Reminders {
  final String? reminderDurationType;
  final String? date;
  final String? time;

  Reminders({
    this.reminderDurationType,
    this.date,
    this.time,
  });

  factory Reminders.fromJson(Map<String, dynamic> json) => Reminders(
        reminderDurationType: json["reminder_duration_type"],
        date: json["date"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "reminder_duration_type": reminderDurationType,
        "date": date,
        "time": time,
      };
}
