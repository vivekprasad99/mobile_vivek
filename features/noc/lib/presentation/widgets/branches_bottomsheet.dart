import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/common_widgets/mf_custom_drop_down.dart';
import 'package:core/config/widgets/common_widgets/mf_custom_text_field.dart';
import 'package:core/config/widgets/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locate_us/data/models/get_branches_res.dart';
import 'package:locate_us/presentation/cubit/locate_us_cubit.dart';
import 'package:noc/presentation/widgets/branch_tile.dart';
import 'package:noc/presentation/cubit/noc_cubit.dart' as noc_cubit;
import 'package:locate_us/data/models/get_cities_res.dart' as get_cities_res;
import 'package:locate_us/data/models/get_states_res.dart' as get_states_res;

class BranchesBottomsheet extends StatelessWidget {
  final String? pincode;
  final List<Branch>? branches;
  final VoidCallback? callback;
  final get_states_res.State? selectedState;
  final get_cities_res.City? selectedCity;
  final List<get_states_res.State>? states;
  final List<get_cities_res.City>? cities;
  final String loanNumber;
  const BranchesBottomsheet({
    super.key,
    this.pincode,
    this.branches,
    this.callback,
    this.selectedState,
    this.selectedCity,
    this.states,
    this.cities,
    required this.loanNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(16.v),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(getString(lblSearchBranch),
              style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 12.v),
          if (pincode != null)
            MfCustomFloatingTextField(
              contentPadding: EdgeInsets.only(left: 8.v),
              labelText: getString(lblLoUsEnterPincode),
              initialValue: pincode,
              isReadOnly: true,
              textInputType: TextInputType.number,
              maxLength: 6,
              textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.textLight,
                      darkColor: AppColors.secondaryLight5,
                    ),
                  ),
              labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.primaryLight,
                      darkColor: AppColors.secondaryLight5,
                    ),
                  ),
              borderDecoration: UnderlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(
                  color: setColorBasedOnTheme(
                    context: context,
                    lightColor: AppColors.primaryLight,
                    darkColor: AppColors.secondaryLight5,
                  ),
                  width: 1,
                ),
              ),
            )
          else
            Row(
              children: [
                //? state
                MfCustomDropDown<get_states_res.State>(
                  title: getString(labelState),
                  menuHeight: 230.h,
                  width: 170.v,
                  initialValue: selectedState,
                  dropdownMenuEntries: states!
                      .map(
                        (e) => DropdownMenuEntry(
                          value: e,
                          label: e.stateName ?? '',
                        ),
                      )
                      .toList(),
                ),
                SizedBox(width: 18.v),

                //? city
                MfCustomDropDown(
                  title: getString(labelCity),
                  width: 170..v,
                  menuHeight: 230.h,
                  initialValue: selectedCity,
                  dropdownMenuEntries: cities!
                      .map(
                        (e) => DropdownMenuEntry(
                          value: e,
                          label: e.cityName ?? '',
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          SizedBox(height: 12.v),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.4,
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 8.v),
              shrinkWrap: true,
              itemCount: branches?.length ?? 0,
              itemBuilder: (context, index) {
                if (branches?[index] != null) {
                  return BranchTile(branch: branches![index]);
                }
                return Container();
              },
            ),
          ),
          SizedBox(height: 24.v),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MfCustomButton(
                  width: MediaQuery.of(context).size.width * 0.44,
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (callback != null) {
                      callback!();
                    }
                  },
                  text: getString(lblBack),
                  outlineBorderButton: true),
              BlocBuilder<LocateUsCubit, LocateUsState>(
                builder: (context, state) {
                  return MfCustomButton(
                    width: MediaQuery.of(context).size.width * 0.44,
                    onPressed: () {
                      if (state is SelectBranchState) {
                        context
                            .read<noc_cubit.NocCubit>()
                            .selectedPrefferedAddress(
                                state.branch, state.branch?.name,loanNumber);
                      }
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    text: getString(lblNocFeatureContinue),
                    outlineBorderButton: false,
                    isDisabled: state is! SelectBranchState,
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 8.v),
        ],
      ),
    );
  }
}
