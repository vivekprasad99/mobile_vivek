import 'package:common/features/startup/data/models/validate_device_response.dart';

class SecondFactorAuthArg {
  String? prePopulatedAuthNumber;
  bool? isMultipleUCIC;
  String? headerDesc;
  Profiles? currentProfile;

  SecondFactorAuthArg({this.prePopulatedAuthNumber, this.isMultipleUCIC, this.headerDesc, this.currentProfile});
}