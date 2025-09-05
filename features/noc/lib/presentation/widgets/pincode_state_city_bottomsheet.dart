import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/common_widgets/mf_custom_drop_down.dart';
import 'package:core/config/widgets/common_widgets/mf_custom_text_field.dart';
import 'package:core/config/widgets/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:locate_us/data/models/get_branches_pincode_req.dart';
import 'package:locate_us/data/models/get_branches_state_city_req.dart';
import 'package:locate_us/data/models/get_cities_req.dart';
import 'package:locate_us/data/models/get_cities_res.dart' as get_cities_res;
import 'package:locate_us/data/models/get_states_res.dart' as get_states_res;
import 'package:locate_us/presentation/cubit/locate_us_cubit.dart';
import 'package:noc/presentation/cubit/noc_cubit.dart' as noc_cubit;
import 'package:noc/presentation/widgets/branches_bottomsheet.dart';

class PincodeStateCityBottomsheet extends StatefulWidget {
  final String loanNumber;
  const PincodeStateCityBottomsheet({super.key,required this.loanNumber});

  @override
  PincodeStateCityBottomsheetState createState() =>
      PincodeStateCityBottomsheetState();
}

class PincodeStateCityBottomsheetState
    extends State<PincodeStateCityBottomsheet> {
  final TextEditingController pincode = TextEditingController();
  final TextEditingController state = TextEditingController();
  final TextEditingController city = TextEditingController();
  Key pincodeKey = UniqueKey();
  Key stateKey = UniqueKey();
  List<get_states_res.State> states = [];
  List<get_cities_res.City> cities = [];

  get_states_res.State? selectedState;
  get_cities_res.City? selectedCity;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<LocateUsCubit>().getStates();
    });
  }

  void handleSelectPincode(val) {
    if (selectedState != null) {
      setState(() {
        stateKey = UniqueKey();
        selectedState = null;
        selectedCity = null;
        cities = [];
      });
    }
  }

  void handleSearch() async {
    if (selectedState != null && selectedCity != null) {
      context.read<LocateUsCubit>().getBranchesFromStateCity(
            req: GetBranchesStateCityRequest(
              stateCode: selectedState!.stateCode ?? -1,
              cityCode: selectedCity!.cityCode ?? -1,
              onlyDealers: false,
            ),
          );
    } else if (pincode.text.isNotEmpty) {
      context.read<LocateUsCubit>().getBranchesFromPincode(
            req: GetBranchesPincodeRequest(
              pincode: pincode.text,
              onlyDealers: false,
            ),
          );
    } else {
      toastForFailureMessage(
        context: context,
        msg: getString(msgLoUsSelectPinOrStateCity),
      );
    }
  }

  void handleSelectState(get_states_res.State state) {
    if (state.stateCode != null) {
      Future.delayed(const Duration(seconds: 0), () {
        pincodeKey = UniqueKey();
        pincode.clear();
        selectedCity = null;
        cities = [];
        selectedState = state;
      });
      context.read<LocateUsCubit>().getCities(
            GetCitiesRequest(
              stateCode: state.stateCode!,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocateUsCubit, LocateUsState>(
        listener: (context, state) {
      if (state is LoadingState) {
        if (state.isLoading) {
          showLoaderDialog(context, getString(lblLeadGenLoading));
        } else {
          Navigator.of(context, rootNavigator: true).pop();
        }
      } else if (state is GetStateSuccessState) {
        if (state.states.code == AppConst.codeFailure) {
          toastForFailureMessage(
            context: context,
            msg: getString(state.states.responseCode ?? ""),
          );
        } else {
          states = [...state.states.stateList ?? []];
          states.sort(
            (a, b) {
              return a.stateName?.compareTo(b.stateName ?? '') ?? 1;
            },
          );
        }
      } else if (state is GetCitiesSuccessState) {
        if (state.cities.code == AppConst.codeFailure) {
          toastForFailureMessage(
              context: context,
              msg: getString(state.cities.responseCode ?? ""),
              duration: const Duration(seconds: 5));
        } else {
          cities = [...state.cities.cityList ?? []];
          cities.sort(
            (a, b) {
              return a.cityName?.compareTo(b.cityName ?? '') ?? 1;
            },
          );
        }
      } else if (state is GetBranchesSuccessState) {
        if (state.branches.code == AppConst.codeFailure) {
          toastForFailureMessage(
              context: context,
              msg: getString(state.branches.responseCode ?? ""),
              duration: const Duration(seconds: 5));
        } else {
          // if (widget.isForDealer) {
          //   context.pop(state.dealers);
          // } else {
          //   context.pushNamed(
          //     Routes.locateUsBranches.name,
          //     extra: [state.branches, state.dealers, state.saved],
          //   );
          // }
          // context.pop();
          if (pincode.text.isNotEmpty) {
            showModalBottomSheet(
              context: context,
              builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                      value: BlocProvider.of<LocateUsCubit>(context)),
                  BlocProvider.value(
                      value: BlocProvider.of<noc_cubit.NocCubit>(context)),
                ],
                child: BranchesBottomsheet(
                  loanNumber: widget.loanNumber,
                    pincode: pincode.text,
                    callback: () {
                      pincode.text = "";
                    },
                    branches: state.branches.branchList),
              ),
            );
          } else if (selectedCity != null && selectedState != null) {
            showModalBottomSheet(
              context: context,
              builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                      value: BlocProvider.of<LocateUsCubit>(context)),
                  BlocProvider.value(
                      value: BlocProvider.of<noc_cubit.NocCubit>(context)),
                ],
                child: BranchesBottomsheet(
                  loanNumber: widget.loanNumber,
                    selectedCity: selectedCity,
                    selectedState: selectedState,
                    states: states,
                    cities: cities,
                    branches: state.branches.branchList),
              ),
            );
          }
        }
      } else if (state is GetDealersSuccessState) {
        if (state.dealers.code == AppConst.codeFailure) {
          toastForFailureMessage(
              context: context,
              msg: getString(state.dealers.responseCode ?? ""),
              duration: const Duration(seconds: 5));
        } else {
          context.pop(state.dealers);
        }
      } else if (state is FailureState) {
        toastForFailureMessage(
            context: context,
            msg: getFailureMessage(state.failure),
            duration: const Duration(seconds: 5));
      }
    }, builder: (context, state) {
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
            MfCustomFloatingTextField(
              contentPadding: EdgeInsets.only(left: 8.v),
              labelText: getString(lblLoUsEnterPincode),
              controller: pincode,
              onChange: (val) {
                if (pincode.text.length == 6) {
                  handleSearch();
                } else if (selectedCity != null || selectedState != null) {
                  setState(() {
                    selectedCity = null;
                    selectedState = null;
                  });
                }
              },
              onTap: () {},
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
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
            ),
            SizedBox(height: 12.v),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(getString(lblOr),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontWeight: FontWeight.w400)),
              ],
            ),
            SizedBox(height: 12.v),
            Row(
              children: [
                //? state
                MfCustomDropDown<get_states_res.State>(
                  key: stateKey,
                  title: getString(labelState),
                  menuHeight: 230.h,
                  width: 170.v,
                  onSelected: (state) {
                    if (state != null) {
                      handleSelectState(state);
                    }
                  },
                  dropdownMenuEntries: states
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
                  key: ValueKey(selectedState),
                  title: getString(labelCity),
                  width: 170..v,
                  menuHeight: 230.h,
                  onSelected: (city) {
                    selectedCity = city;
                  },
                  dropdownMenuEntries: cities
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
            SizedBox(
              height: 24.v,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MfCustomButton(
                    width: MediaQuery.of(context).size.width * 0.44,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    text: getString(lblBack),
                    outlineBorderButton: true),
                BlocBuilder<LocateUsCubit, LocateUsState>(
                  builder: (context, state) {
                    return MfCustomButton(
                      width: MediaQuery.of(context).size.width * 0.44,
                      onPressed: () {
                        if ((selectedCity != null && selectedState != null)) {
                          context
                              .read<LocateUsCubit>()
                              .getBranchesFromStateCity(
                                req: GetBranchesStateCityRequest(
                                  stateCode: selectedState!.stateCode ?? -1,
                                  cityCode: selectedCity!.cityCode ?? -1,
                                  onlyDealers: false,
                                ),
                              );
                        }
                        // if (state is SelectAddressState) {
                        //   context
                        //       .read<noc_cubit.NocCubit>()
                        //       .selectedPrefferedAddress(
                        //           state.address, state.addressType);
                        // }
                        // Navigator.of(context).pop();
                      },
                      text: getString(lblNocFeatureContinue),
                      outlineBorderButton: false,
                      isDisabled: (state is GetBranchesSuccessState &&
                              state.branches.code == AppConst.codeFailure) ||
                          (selectedCity == null && selectedState == null),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}
