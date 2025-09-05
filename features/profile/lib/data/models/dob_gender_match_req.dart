class DobGenderMatchRequest {
  String? sourceDob;
  String? targetDob;
  String? sourceGender;
  String? targetGender;

  DobGenderMatchRequest(
      {this.sourceDob, this.targetDob, this.sourceGender, this.targetGender});

  DobGenderMatchRequest.fromJson(Map<String, dynamic> json) {
    sourceDob = json['sourceDob'];
    targetDob = json['targetDob'];
    sourceGender = json['sourceGender'];
    targetGender = json['targetGender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sourceDob'] = sourceDob;
    data['targetDob'] = targetDob;
    data['sourceGender'] = sourceGender;
    data['targetGender'] = targetGender;
    return data;
  }
}
