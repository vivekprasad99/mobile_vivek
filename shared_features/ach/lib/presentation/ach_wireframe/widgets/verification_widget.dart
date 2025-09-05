import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/ach_util.dart';
import '../../../data/models/fetch_bank_accoun_response.dart';
import '../../../data/models/get_bank_list_resp.dart';
import '../../cubit/ach_cubit.dart';

class VerificationOptionWidget extends StatefulWidget {
  const VerificationOptionWidget({
    super.key,
  });

  @override
  State<VerificationOptionWidget> createState() => _VerificationOptionWidgetState();
}

class _VerificationOptionWidgetState extends State<VerificationOptionWidget> {
  int visibleBanks = 2;
  VerificationOption? verificationOption;

  String? bankName;
  BankData? bank;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AchCubit, AchState>(
      buildWhen: (prevous, curr) => curr is SelectNewBankState,
      builder: (context, state) {
        final bool lightTheme = Theme.of(context).brightness == Brightness.light;
        if (state is SelectNewBankState && state.bank != null) {
          int? count = state.bank?.verificationOption!.length;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.v),
              Text(
                getString(msgVerificationOptions),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(letterSpacing: 0.15),
              ),
              SizedBox(height: 10.v),
              SizedBox(
                height: 500,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: count! > visibleBanks ? visibleBanks + 1 : state.bank?.verificationOption?.length,
                  // +1 for the "View More" or "View Less" option
                  itemBuilder: (BuildContext context, int index) {
                    if (index == visibleBanks) {
                      // Display "View More" or "View Less" option
                      return Align(alignment: Alignment.topCenter,
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                visibleBanks < (state.bank?.verificationOption?.length ?? 0)
                                    ? getString(lblOtherOption)
                                    : "",
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: setColorBasedOnTheme(
                                        context: context,
                                        lightColor: AppColors.secondaryLight,
                                        darkColor: AppColors.primaryLight5)),
                              ),
                              visibleBanks < (state.bank?.verificationOption?.length ?? 0)
                                  ? Icon(Icons.arrow_drop_down_outlined,
                                  color: setColorBasedOnTheme(
                                      context: context,
                                      lightColor: AppColors.secondaryLight,
                                      darkColor: AppColors.primaryLight5))
                                  : const SizedBox()
                            ],
                          ),
                          onTap: () {
                            setState(() {
                              visibleBanks = (visibleBanks < (state.bank?.verificationOption?.length ?? 0))
                                  ? (state.bank?.verificationOption?.length ?? 0)
                                  : 2;
                            });
                          },
                        ),
                      );
                    } else {
                      return BlocBuilder<AchCubit, AchState>(
                        builder: (context, state2) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                verificationOption = state.bank?.verificationOption?[index];
                                context.read<AchCubit>().selectNewBankVerifyOption(verificationOption, state.bank);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: verificationOption == state.bank?.verificationOption?[index]
                                          ? lightTheme
                                          ? AppColors.primaryLight4
                                          : AppColors.white
                                          : Theme.of(context).cardColor,
                                      width: 1),
                                  boxShadow: verificationOption == state.bank?.verificationOption![index]
                                      ? [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.4),
                                      offset: const Offset(1.0, 1.0), //(x,y)
                                      blurRadius: 3.0,
                                    ),
                                  ]
                                      : null,
                                ),
                                child: ListTile(
                                    leading: Padding(
                                      padding: const EdgeInsets.only(right: 0.0),
                                      child: SvgPicture.asset(
                                        width: 25,
                                        height: 19,
                                        state.bank?.verificationOption?[index].optionId ==
                                            VerificationMode.debitCard.value
                                            ? ImageConstant.debitIcon
                                            : state.bank?.verificationOption?[index].optionId ==
                                            VerificationMode.netBanking.value
                                            ? ImageConstant.netbankingIcon
                                            : state.bank?.verificationOption?[index].optionId ==
                                            VerificationMode.aadhaar.value
                                            ? ImageConstant.walletIcon
                                            : state.bank?.verificationOption?[index].optionId ==
                                            VerificationMode.upi.value
                                            ? ImageConstant.upiIcon
                                            : "",
                                        colorFilter: ColorFilter.mode(
                                            setColorBasedOnTheme(
                                                context: context,
                                                lightColor: Theme.of(context).primaryColor,
                                                darkColor: Colors.white),
                                            BlendMode.srcIn),
                                      ),
                                    ),
                                    title: Text(state.bank?.verificationOption?[index].optionName ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(fontWeight: FontWeight.w500)),
                                    contentPadding: const EdgeInsets.only(left: 12, right: 12),
                                    trailing: Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: SizedBox(
                                        width: 120,
                                        height: double.maxFinite,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(),
                                            verificationOption == state.bank?.verificationOption?[index]
                                                ? Padding(
                                              padding: const EdgeInsets.only(right: 8.0),
                                              child: Icon(
                                                Icons.check_circle_outline,
                                                color: Theme.of(context).primaryColor,
                                                size: 16.h,
                                              ),
                                            )
                                                : state.bank?.verificationOption?[index].isRecommended == true
                                                ? Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: AppColors.primaryLight6,
                                              ),
                                              child: Text(
                                                getString(lblRecommended),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall
                                                    ?.copyWith(color: AppColors.textLight, fontSize: 11.0),
                                              ),
                                            )
                                                : const SizedBox(),
                                          ],
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}