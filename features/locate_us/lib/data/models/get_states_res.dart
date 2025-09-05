class GetStatesResponse {
  final String? code;
  final String? message;
  final String? responseCode;
  final List<State>? stateList;

  GetStatesResponse({
    this.code,
    this.message,
    this.responseCode,
    this.stateList,
  });

  factory GetStatesResponse.fromJson(Map<String, dynamic> json) =>
      GetStatesResponse(
        code: json["code"],
        message: json["message"],
        responseCode: json["responseCode"],
        stateList: json["stateList"] == null
            ? []
            : List<State>.from(
                json["stateList"]!.map((x) => State.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "responseCode": responseCode,
        "stateList": stateList == null
            ? []
            : List<dynamic>.from(stateList!.map((x) => x.toJson())),
      };
}

class State {
  final int? stateCode;
  final String? stateName;

  State({
    this.stateCode,
    this.stateName,
  });

  factory State.fromJson(Map<String, dynamic> json) => State(
        stateCode: json["stateCode"],
        stateName: json["stateName"],
      );

  Map<String, dynamic> toJson() => {
        "stateCode": stateCode,
        "stateName": stateName,
      };
}
