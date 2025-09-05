class ReopenCaseRequest {
  String? caseNumber;
  String? reopenRemark;
  String? reopenUnsatisfiedRemark;
  String? sourceSystem;

  ReopenCaseRequest({this.caseNumber, this.reopenRemark, this.reopenUnsatisfiedRemark, this.sourceSystem});

  ReopenCaseRequest.fromJson(Map<String, dynamic> json) {
    caseNumber = json['caseNumber'];
    reopenRemark = json['reopenRemark'];
    reopenUnsatisfiedRemark = json['reopenUnsatisfiedRemark'];
    sourceSystem = json['sourceSystem'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['caseNumber'] = caseNumber;
    data['reopenRemark'] = reopenRemark;
    data['reopenUnsatisfiedRemark'] = reopenUnsatisfiedRemark;
    data['sourceSystem'] = sourceSystem;
    return data;
  }
}