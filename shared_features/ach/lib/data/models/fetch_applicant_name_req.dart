class FetchApplicantNameReq {
  String? ucic;
  String? loanNumber;
  String? cif;
  String? sourceSystem;
  String? superAppId;
  String? source;

  FetchApplicantNameReq({this.ucic, this.loanNumber, this.cif, this.sourceSystem, this.superAppId, this.source});

  FetchApplicantNameReq.fromJson(Map<String, dynamic> json) {
    ucic = json['ucic'];
    loanNumber = json['loanNumber'];
    cif = json['cif'];
    sourceSystem = json['sourceSystem'];
    superAppId = json['superAppId'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ucic'] = ucic;
    data['loanNumber'] = loanNumber;
    data['cif'] = cif;
    data['sourceSystem'] = sourceSystem;
    data['superAppId'] = superAppId;
    data['source'] = source;
    return data;
  }
}