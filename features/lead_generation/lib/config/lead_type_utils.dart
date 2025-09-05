isVehicleLeadType(String leadType) {
  return leadType == 'tractor' ||
      leadType == 'new_car' ||
      leadType == 'utility_vehicle' ||
      leadType == 'commercial_vehicle' ||
      leadType == 'used_car' ||
      leadType == 'three_wheeler' ||
      leadType == "balance_transfer" ||
      leadType == "two_wheeler";
}
