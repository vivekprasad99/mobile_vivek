import 'package:profile/data/models/validate_license_response.dart';
import 'package:profile/utils/utils.dart';

class ValidateDrivingLicenseDetail{
  String? drivingLicenseNo;
  String? dob;
 Address? address;
  String? custName;
  AddressType? addressType;

  ValidateDrivingLicenseDetail({this.drivingLicenseNo, this.dob, this.address, this.custName,this.addressType});
}