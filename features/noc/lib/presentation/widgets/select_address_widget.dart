import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:noc/presentation/cubit/noc_cubit.dart' as noc_cubit;
import 'package:noc/presentation/widgets/address_tile.dart';
import 'package:profile/config/routes/route.dart';
import 'package:profile/data/models/my_profile_model_request.dart';
import 'package:profile/presentation/cubit/profile_cubit.dart';
import 'package:profile/utils/utils.dart';

class SelectAddressBottomSheet extends StatefulWidget {
  final String loanNumber;
  const SelectAddressBottomSheet({super.key,required this.loanNumber});

  @override
  State<SelectAddressBottomSheet> createState() =>
      _SelectAddressBottomSheetState();
}

class _SelectAddressBottomSheetState extends State<SelectAddressBottomSheet> {
  @override
  void initState() {
    context.read<ProfileCubit>().getMyProfile(MyProfileRequest(
        ucic: getUCIC(), superAppId: getSuperAppId(), source: AppConst.source));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(16.v),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        buildWhen: (previous, current) => current is MyProfileSuccessState,
        builder: (context, state) {
          if (state is ProfileLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MyProfileSuccessState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(getString(lblDeliveryAddress),
                        style: Theme.of(context).textTheme.titleLarge),
                    BlocBuilder<ProfileCubit, ProfileState>(
                      buildWhen: (previous, current) =>
                          current is SelectAddressState,
                      builder: (context, updateState) {
                        if (updateState is SelectAddressState) {
                          return GestureDetector(
                            onTap: () {
                              if (updateState.addressType ==
                                  getString(lblPermanentAddress)) {
                                context.pushNamed(
                                    Routes.myProfileUpdateAddress.name,
                                    extra: {
                                      "addressType": AddressType.permanent,
                                      "profileData": state.response
                                    });
                              } else if (updateState.addressType ==
                                  getString(lblCurrentAccount)) {
                                context.pushNamed(
                                    Routes.myProfileUpdateAddress.name,
                                    extra: {
                                      "addressType": AddressType.current,
                                      "profileData": state.response
                                    });
                              }
                            },
                            child: Text(
                              getString(lblNocFeatureUpdate),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: setColorBasedOnTheme(
                                        context: context,
                                        lightColor: AppColors.secondaryLight,
                                        darkColor: AppColors.secondaryLight5),
                                  ),
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 12.v),
                if (state.response.data?.permanentAddr != null)
                  AddressTile(
                    address: state.response.data!.permanentAddr!,
                    title: getString(lblCurrentAddress),
                  ),
                SizedBox(height: 6.v),
                if (state.response.data?.communicationAddr != null)
                  AddressTile(
                    address: state.response.data!.communicationAddr!,
                    title: getString(lblPermanentAddress),
                  ),
                SizedBox(height: 24.v),
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
                    BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        return MfCustomButton(
                            width: MediaQuery.of(context).size.width * 0.44,
                            onPressed: () {
                              if (state is SelectAddressState) {
                                context
                                    .read<noc_cubit.NocCubit>()
                                    .selectedPrefferedAddress(
                                        state.address, state.addressType,widget.loanNumber);
                              }
                              Navigator.of(context).pop();
                            },
                            text: getString(lblNocFeatureContinue),
                            outlineBorderButton: false);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8.v),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
