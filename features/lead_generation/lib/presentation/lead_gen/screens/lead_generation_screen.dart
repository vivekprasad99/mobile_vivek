import 'package:core/config/string_resource/strings.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lead_generation/config/lead_type.dart';
import 'package:lead_generation/config/lead_type_utils.dart';
import 'package:lead_generation/presentation/cubit/lead_generation_cubit.dart';
import 'package:lead_generation/presentation/lead_gen/screens/widget/lead_type_mibl_widget.dart';
import 'package:lead_generation/presentation/lead_gen/screens/widget/lead_type_pl_widget.dart';
import 'package:lead_generation/presentation/lead_gen/screens/widget/lead_type_sme_widget.dart';
import 'package:lead_generation/presentation/lead_gen/screens/widget/lead_type_vehicle_top_up.dart';
import 'package:lead_generation/presentation/lead_gen/screens/widget/lead_type_vehicle_widgets.dart';

import 'widget/lead_type_common_widget.dart';

class LeadGenerationScreen extends StatefulWidget {
  final String? leadType;
  final String? vertical;

  const LeadGenerationScreen({
    super.key,
    this.leadType,
    this.vertical,
  });

  @override
  State<LeadGenerationScreen> createState() => _LeadGenerationScreenState();
}

class _LeadGenerationScreenState extends State<LeadGenerationScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LeadGenerationCubit>(
        create: (context) => di<LeadGenerationCubit>(),
        child: bodyWidget(widget.leadType ?? ""));
  }

  Widget bodyWidget(String leadType) {
    if (leadType == 'sme') {
      return const LeadTypeSmeWidget();
    } else if (leadType == 'personal') {
      return const LeadTypePlWidget();
    } else if (leadType == 'motor' ||
        leadType == 'health' ||
        leadType == 'life' ||
        leadType == 'travel') {
      return LeadTypeMiblWidget(
        leadType: leadType,
      );
      // } else if (leadType == 'health') {
      // return LeadTypeCommonWidget(
      //     leadTypeCode: LeadType.mibl.value, title: getString(lblInsurance));
    } else if (leadType == 'fixed_deposit') {
      return LeadTypeCommonWidget(
          leadTypeCode: LeadType.fd.value, title: getString(fixedDepositLabel));
    } else if (isVehicleLeadType(leadType)) {
      return LeadTypeVehicleWidget(
        vehicleType: leadType.equalsIgnoreCase("balance_transfer")
            ? "new_car"
            : leadType,
        vertical: widget.vertical,
        title: getTitle(leadType),
        altText: leadType == "balance_transfer"
            ? getString(lblWeneedfewmoredetailstoprocess)
            : null,
      );
    } else if (leadType == "vehicle_top_up") {
      return const LeadTypeVehicleTopUp(isVehicle: true);

      // } else if (leadType == "balance_transfer") {
      //   return LeadTypeVehicleTopUp();
    } else if (leadType == "personal_top_up") {
      return const LeadTypeVehicleTopUp(isVehicle: false);
    } else {
      return LeadTypeCommonWidget(
          leadTypeCode:
              leadType == "home" ? LeadType.rhl.value : LeadType.vl.value,
          title: leadType == "home"
              ? getString(lblHomeLoan)
              : getString(lblLeadGen));
    }
  }
}

String getTitle(String leadType) {
  switch (leadType) {
    case "tractor":
      return getString(lblTractor);
    case "three_wheeler":
      return getString(lblThreeWheeler);
    case "new_car":
      return getString(lblNewCar);
    case "used_car":
      return getString(lblUsedCar);
    case "utility_vehicle":
      return getString(lblUtilityVehicle);
    case "commercial_vehicle":
      return getString(msgCommercialVehicle);
    case "two_wheeler":
      return getString(lblTwoWheeler);
    case "balance_transfer":
      return getString(lblbalancetransfer);
  }
  return leadType;
}
