import 'package:common/features/startup/data/models/validate_device_response.dart';

import '../../../data/models/my_profile_model_response.dart';

class ProfileSecondFactorArg {
  String? prePopulatedAuthNumber;
  bool? isMultipleUCIC;
  String? headerDesc;
  Profiles? currentProfile;
  final ProfileInfo? profileInfo;

  ProfileSecondFactorArg({this.prePopulatedAuthNumber, this.isMultipleUCIC, this.headerDesc, this.currentProfile, this.profileInfo});
}