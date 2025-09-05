class ValidatePANResponse {
  String? code;
  String? message;
  String? responseCode;
  String? status;
  List<PANStatusDetails>? pANStatusDetails;

  ValidatePANResponse(
      {this.code,
      this.message,
      this.responseCode,
      this.status,
      this.pANStatusDetails});

  ValidatePANResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    responseCode = json['responseCode'];
    status = json['status'];
    if (json['PAN_Status_Details'] != null) {
      pANStatusDetails = <PANStatusDetails>[];
      json['PAN_Status_Details'].forEach((v) {
        pANStatusDetails!.add(PANStatusDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['responseCode'] = responseCode;
    data['status'] = status;
    if (pANStatusDetails != null) {
      data['PAN_Status_Details'] =
          pANStatusDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PANStatusDetails {
  String? pan;
  String? aadhaarSeedingStatus;
  String? fathernameMatchingStatus;
  String? panRemarks;
  String? panStatusDesc;
  String? dobMatchingStatus;
  String? panStatus;
  String? nameMatchingStatus;

  PANStatusDetails(
      {this.pan,
      this.aadhaarSeedingStatus,
      this.fathernameMatchingStatus,
      this.panRemarks,
      this.panStatusDesc,
      this.dobMatchingStatus,
      this.panStatus,
      this.nameMatchingStatus});

  PANStatusDetails.fromJson(Map<String, dynamic> json) {
    pan = json['pan'];
    aadhaarSeedingStatus = json['aadhaar_seeding_status'];
    fathernameMatchingStatus = json['fathername_matching_status'];
    panRemarks = json['pan_remarks'];
    panStatusDesc = json['pan_status_desc'];
    dobMatchingStatus = json['dob_matching_status'];
    panStatus = json['pan_status'];
    nameMatchingStatus = json['name_matching_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pan'] = pan;
    data['aadhaar_seeding_status'] = aadhaarSeedingStatus;
    data['fathername_matching_status'] = fathernameMatchingStatus;
    data['pan_remarks'] = panRemarks;
    data['pan_status_desc'] = panStatusDesc;
    data['dob_matching_status'] = dobMatchingStatus;
    data['pan_status'] = panStatus;
    data['name_matching_status'] = nameMatchingStatus;
    return data;
  }
}
