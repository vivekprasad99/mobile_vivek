import '../../utils/utils.dart';
import 'my_profile_model_response.dart';

class ProfileExtras{

  String? custName;
  String? aadhaarNumber;
  String? newPhoneNumber;
  String? transactionId;
  String? oldEmailId;
  String? newEmail;
  Operation? operation;
  ProfileInfo? profileInfo;
  AddressType? addressType;

  ProfileExtras({ this.custName, this.aadhaarNumber, this.newPhoneNumber, this.transactionId, this.oldEmailId, this.newEmail, this.operation, this.profileInfo, this.addressType});
}