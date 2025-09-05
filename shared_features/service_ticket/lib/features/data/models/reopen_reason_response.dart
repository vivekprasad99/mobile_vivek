class ReopenReasonResponse {
  List<ReopenReason>? data;

  ReopenReasonResponse({this.data});

  ReopenReasonResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ReopenReason>[];
      json['data'].forEach((v) {
        data!.add(ReopenReason.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReopenReason {
  int? id;
  String? value;

  ReopenReason({this.id, this.value});

  ReopenReason.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['value'] = value;
    return data;
  }
}
