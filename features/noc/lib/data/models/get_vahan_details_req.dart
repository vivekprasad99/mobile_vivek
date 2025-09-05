class GetVahanDetailsReq {
  final String? rcNumber;

  GetVahanDetailsReq({
    this.rcNumber,
  });

  factory GetVahanDetailsReq.fromJson(Map<String, dynamic> json) =>
      GetVahanDetailsReq(
        rcNumber: json["rc_number"],
      );

  Map<String, dynamic> toJson() => {
        "rc_number": rcNumber,
      };
}
