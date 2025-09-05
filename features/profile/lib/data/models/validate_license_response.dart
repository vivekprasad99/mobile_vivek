class ValidateLicenseResponse {
  String? code;
  String? message;
  String? responseCode;
  String? name;
  String? profileImage;
  String? dob;
  String? status;
  Address? address;

  ValidateLicenseResponse(
      {this.code,
      this.message,
      this.responseCode,
      this.name,
      this.profileImage,
      this.status,
      this.address});

  ValidateLicenseResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    responseCode = json['responseCode'];
    name = json['name'];
    profileImage = json['profileImage'];
    dob = json['dob'];
    status = json['status'];
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['responseCode'] = responseCode;
    data['name'] = name;
    data['profileImage'] = profileImage;
    data['status'] = status;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    return data;
  }
}

class Address {
  String? addressLine1;
  String? completeAddress;
  String? district;
  String? state;
  String? country;
  String? postalCode;

  Address(
      {this.addressLine1,
      this.completeAddress,
      this.district,
      this.state,
      this.country,
      this.postalCode});

  Address.fromJson(Map<String, dynamic> json) {
    addressLine1 = json['addressLine1'];
    completeAddress = json['completeAddress'];
    district = json['district'];
    state = json['state'];
    country = json['country'];
    postalCode = json['postalCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['addressLine1'] = addressLine1;
    data['completeAddress'] = completeAddress;
    data['district'] = district;
    data['state'] = state;
    data['country'] = country;
    data['postalCode'] = postalCode;
    return data;
  }
}
