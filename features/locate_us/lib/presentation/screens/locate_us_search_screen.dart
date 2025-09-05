import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/common_widgets/mf_custom_drop_down.dart';
import 'package:core/config/widgets/common_widgets/mf_custom_text_field.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../config/routes/route.dart';
import '../../data/models/get_branches_pincode_req.dart';
import '../../data/models/get_branches_state_city_req.dart';
import '../../data/models/get_cities_req.dart';
import '../../data/models/get_cities_res.dart' as get_cities_res;
import '../../data/models/get_states_res.dart' as get_states_res;
import '../cubit/locate_us_cubit.dart';
import '../widgets/locate_us_icon_button.dart';

class LocateUsSearchScreen extends StatefulWidget {
  const LocateUsSearchScreen({
    super.key,
    required this.isForDealer,
  });

  final bool isForDealer;

  @override
  State<LocateUsSearchScreen> createState() => _LocateUsSearchScreenState();
}

class _LocateUsSearchScreenState extends State<LocateUsSearchScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<LocateUsCubit>().getStates();
    });
  }

  final pincodeController = TextEditingController();
  Key pincodeKey = UniqueKey();
  Key stateKey = UniqueKey();

  List<get_states_res.State> states = [];
  List<get_cities_res.City> cities = [];

  get_states_res.State? selectedState;
  get_cities_res.City? selectedCity;

  void handleSelectState(get_states_res.State state) {
    if (state.stateCode != null) {
      Future.delayed(const Duration(seconds: 0), () {
        pincodeKey = UniqueKey();
        pincodeController.clear();
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
              onlyDealers: widget.isForDealer,
            ),
          );
    } else if (pincodeController.text.isNotEmpty) {
      context.read<LocateUsCubit>().getBranchesFromPincode(
            req: GetBranchesPincodeRequest(
              pincode: pincodeController.text,
              onlyDealers: widget.isForDealer,
            ),
          );
    } else {
      toastForFailureMessage(
        context: context,
        msg: getString(msgLoUsSelectPinOrStateCity),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        context: context,
        title: getString(lblLoUsLocateUs),
        onPressed: () => Navigator.pop(context),
      ),
      body: BlocConsumer<LocateUsCubit, LocateUsState>(
        listener: (context, state) {
          if (state is LoadingState) {
            if (state.isLoading) {
              showLoaderDialog(context, getString(lblLoUsLoading));
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
              if (widget.isForDealer) {
                context.pop(state.dealers);
              } else {
                context.pushNamed(
                  Routes.locateUsBranches.name,
                  extra: [state.branches, state.dealers, state.saved],
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
        },
        builder: (context, state) {
          return MFGradientBackground(
            horizontalPadding: 0.w,
            child: Padding(
              padding: EdgeInsets.only(left: 16.w),
              child: Column(
                children: [

                  Row(
                    children: [

                      Expanded(
                        child: MfCustomFloatingTextField(
                          key: pincodeKey,
                          labelText: getString(lblLoUsEnterPincode),
                          controller: pincodeController,
                          onChange: handleSelectPincode,
                          onTap: () {},
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          textInputType: TextInputType.number,
                          maxLength: 6,
                          textStyle:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: setColorBasedOnTheme(
                                      context: context,
                                      lightColor: AppColors.textLight,
                                      darkColor: AppColors.secondaryLight5,
                                    ),
                                  ),
                          labelStyle:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                      ),

                      //? locate button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: const LocateUsButton(),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  //? or
                  Text(
                    getString(lblLoUsOr),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                  SizedBox(height: 16.h),

                  //? state & city
                  Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: Row(
                      children: [
                        //? state
                        MfCustomDropDown<get_states_res.State>(
                          key: stateKey,
                          title: getString(lblLoUsState),
                          menuHeight: 230.h,
                          width: 170.w,
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
                        SizedBox(width: 18.w),

                        //? city
                        MfCustomDropDown(
                          key: ValueKey(selectedState),
                          title: getString(lblLoUsCity),
                          width: 170.w,
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
                  ),

                  const Spacer(),

                  //? search button
                  Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: MfCustomButton(
                      onPressed: handleSearch,
                      text: getString(lblLoUsSearch),
                      textStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: AppColors.white,
                              ),
                      outlineBorderButton: false,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
