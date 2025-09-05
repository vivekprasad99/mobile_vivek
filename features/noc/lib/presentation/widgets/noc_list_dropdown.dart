import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/common_widgets/mf_custom_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noc/presentation/cubit/noc_cubit.dart';

class NocListDropdown extends StatefulWidget {
  final String initialValue;
  const NocListDropdown({super.key, required this.initialValue});

  @override
  NocListDropdownState createState() => NocListDropdownState();
}

class NocListDropdownState extends State<NocListDropdown> {
  final TextEditingController controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ButtonStyle menuStyle = MenuItemButton.styleFrom(
      foregroundColor: AppColors.primaryLight,
      textStyle: Theme.of(context)
          .textTheme
          .labelMedium
          ?.copyWith(fontSize: 16, color: AppColors.textLight),
    );
    return MfCustomDropDown(
      initialValue: widget.initialValue,
      title: getString(labelSelectQuery),
      selectedController: controller,
      onSelected: (newValue) {
        context.read<NocCubit>().setNocItem(null, newValue ?? "");
        if (newValue is String) {
          controller.text = newValue;
          context.read<NocCubit>().selectQuery(newValue);
        }
      },
      dropdownMenuEntries: [
        DropdownMenuEntry<String>(
            value: getString(lblNocFeatureViewTrack),
            label: getString(lblNocFeatureViewTrack),
            style: menuStyle),
        DropdownMenuEntry<String>(
            value: getString(lblNocFeatureNotDelivered),
            label: getString(lblNocFeatureNotDelivered),
            style: menuStyle),
        DropdownMenuEntry<String>(
            value: getString(lblNocFeatureDuplicateLostNoc),
            label: getString(lblNocFeatureDuplicateLostNoc),
            style: menuStyle),
      ],
    );
  }
}
