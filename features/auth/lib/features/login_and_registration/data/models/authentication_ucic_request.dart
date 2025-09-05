class AuthenticateMultiUcicRequest {
  String? pan;
  String? lan;
  String? mobileNumber;
  int? authType;
  String? source;
  String? dobAsPerPan;
  String? nameAsPerPan;


  AuthenticateMultiUcicRequest(
      {this.pan,this.lan, this.mobileNumber,this.authType,this.source, this.dobAsPerPan, this.nameAsPerPan});

  AuthenticateMultiUcicRequest.fromJson(Map<String, dynamic> json) {
    pan = json['pan'];
    lan = json['lan'];
    mobileNumber = json['mobileNumber'];
    authType = json['authType'];
    source = json['source'];
    dobAsPerPan = json['dobAsPerPan'];
    nameAsPerPan = json['nameAsPerPan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pan'] = pan;
    data['lan'] = lan;
    data['mobileNumber'] = mobileNumber;
    data['authType'] = authType;
    data['source'] = source;
    data['dobAsPerPan'] = dobAsPerPan;
    data['nameAsPerPan'] = nameAsPerPan;
    return data;
  }
}
