import 'package:common/features/rate_us/presentation/cubit/rate_us_cubit.dart'
    as rate_us;
import 'package:common/features/rate_us/presentation/widget/rate_us_dialog_box.dart';
import 'package:common/features/rate_us/utils/helper/constant_data.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:locate_us/data/models/get_branches_res.dart';
import 'package:noc/config/routes/route.dart';
import 'package:noc/config/util/flag_enums.dart';
import 'package:noc/data/models/noc_details_req.dart';
import 'package:noc/data/models/save_del_req.dart';
import 'package:noc/presentation/cubit/noc_cubit.dart';
import 'package:noc/presentation/widgets/branch_details_widget.dart';
import 'package:noc/presentation/widgets/noc_detail_card.dart';
import 'package:noc/presentation/widgets/noc_msg_container.dart';
import 'package:noc/presentation/widgets/pincode_state_city_bottomsheet.dart';
import 'package:noc/presentation/widgets/preferred_delivery_methoda.dart';
import 'package:noc/presentation/widgets/select_address_widget.dart';
import 'package:profile/data/models/my_profile_model_response.dart';
import 'package:profile/presentation/cubit/profile_cubit.dart' as profile_cubit;
import 'package:locate_us/presentation/cubit/locate_us_cubit.dart' as locate_us_cubit;

class NocDetailsScreen extends StatelessWidget {
  final NocDetailsReq nocDetailsReq;
  const NocDetailsScreen({super.key, required this.nocDetailsReq});

  @override
  Widget build(BuildContext context) {
    context.read<NocCubit>().getNocDetails(nocDetailsReq);
    return Scaffold(
      appBar: customAppbar(
          context: context,
          title: getString(lblNocDetails),
          onPressed: () {
            context.pop();
          }),
      body: MFGradientBackground(
        verticalPadding: 16.v,
        child: BlocListener<rate_us.RateUsCubit, rate_us.RateUsState>(
          listener: (context, state) {
            if (state is rate_us.RateUsSuccessState) {
              if (state.response.code == AppConst.codeSuccess) {
                if (state.response.rateUsStatus ?? false) {
                  showRateUsPopup(context, ConstantData.nocSuccessfulRcUpdate);
                } else {
                  context.pop();
                }
              } else {
                toastForFailureMessage(
                    context: context,
                    msg: getString(
                        state.response.responseCode ?? msgNocMsgSomethingWentWrong));
              }
            } else if (state is rate_us.RateUsFailureState) {
              showSnackBar(
                  context: context, message: getFailureMessage(state.failure));
            }
          },
          child: BlocConsumer<NocCubit, NocState>(
            listener: (context, state) {
              if (state is GetNocDetailsSuccessState &&
                  state.response.code == AppConst.codeFailure) {
                toastForFailureMessage(
                    context: context,
                    msg: getString(
                        state.response.responseCode ?? msgNocMsgSomethingWentWrong),
                    bottomPadding: 40.v);
              }
              else if (state is SaveDeliverySuccessState &&
                  state.response.code == AppConst.codeSuccess) {
                context.pushNamed(Routes.deliverysuccess.name,
                    extra: state.address is Branch);
              } else if (state is SaveDeliverySuccessState &&
                  state.response.code == AppConst.codeFailure) {
                context.pushNamed(Routes.somethingWentWrongScreen.name);
              }
              else if(state is SaveDeliveryLoadingState){
                if(state.isLoading){
                showLoaderDialog(context, getString(lblNocLoading));
                }else{
                Navigator.of(context, rootNavigator: true).pop();
                }
              }
            },
            buildWhen: (previous, current) =>
                current is GetNocDetailsSuccessState,
            builder: (context, state) {
              if (state is GetNocDetailsSuccessState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.response.data != null)
                      NocMsgContainer(
                        data: state.response.data!,
                        rcUpdate: nocDetailsReq.containsRc &&
                            !(state.response.data?.netSettlementAmt != null &&
                                state.response.data?.netSettlementAmt!
                                        .isNotEmpty ==
                                    true &&
                                !(state.response.data?.netSettlementAmt
                                        ?.contains("-") ==
                                    true)),
                      ),
                    SizedBox(height: 16.v),
                    state.response.data != null
                        ? NocDetailCard(
                            nocData: state.response.data!,
                            rcUpdate: nocDetailsReq.containsRc &&
                                !(state.response.data?.netSettlementAmt !=
                                        null &&
                                    state.response.data?.netSettlementAmt!
                                            .isNotEmpty ==
                                        true &&
                                    !(state.response.data?.netSettlementAmt
                                            ?.contains("-") ==
                                        true)),
                          )
                        : Container(),
                    if (state.response.data != null &&
                        state.response.data?.branchName != null &&
                        state.response.data?.branchName?.isNotEmpty == true &&
                        state.response.data?.branchLocation != null &&
                        state.response.data?.branchLocation?.isNotEmpty ==
                            true &&
                        state.response.data?.handoverTo
                                ?.equalsIgnoreCase("RTO") ==
                            false)
                      BranchDetailsWidget(
                        branchName: state.response.data?.branchName,
                        branchLocation: state.response.data?.branchLocation,
                      ),
                    SizedBox(height: 16.v),
                    if (state.response.data != null &&
                        state.response.data?.nocStatus != null &&
                        (state.response.data?.nocStatus!.contains("2") ==
                                true ||
                            state.response.data?.nocStatus?.equalsIgnoreCase(
                                    nocStatusString.print.value) ==
                                true) &&
                        state.response.data?.handoverTo != null &&
                        state.response.data?.handoverTo
                                ?.equalsIgnoreCase("RTO") ==
                            true)
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.v),
                            color: setColorBasedOnTheme(
                                context: context,
                                lightColor: Colors.white,
                                darkColor: AppColors.cardDark)),
                        child: Padding(
                          padding: EdgeInsets.all(16.0.v),
                          child: Text(
                            getString(noteNocValidity),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ),
                    if (state.response.data != null&&!nocDetailsReq.containsRc &&
                        state.response.data?.nocStatus == null &&
                        state.response.data?.netSettlementAmt == null &&
                        (DateTime.tryParse(state.response.data?.endDate ??
                                        DateTime.now().toIso8601String()) ??
                                    DateTime.now())
                                .difference(DateTime.now())
                                .inDays <=
                            30)
                      SelectPreferredMethod(
                        loanNumber:
                            state.response.data?.loanAccountNumber ?? "",
                      ),
                    BlocBuilder<NocCubit, NocState>(
                      buildWhen: (previous, current) =>
                          current is SelectedPrefferedAddressState ||
                          current is PreferredMethodState,
                      builder: (context, state) {
                        if (state is SelectedPrefferedAddressState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0.v),
                                child: Divider(
                                  color: setColorBasedOnTheme(
                                      context: context,
                                      lightColor: AppColors.primaryLight6,
                                      darkColor: AppColors.shadowDark),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getString(lblDeliveryAddress),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  BlocBuilder<NocCubit, NocState>(
                                    builder: (context, state) {
                                      return GestureDetector(
                                        onTap: () {
                                          if (state is PreferredMethodState) {
                                            if (state.preferredMethod ==
                                                PreferredMethod.address) {
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder: (_) =>
                                                      MultiBlocProvider(
                                                          providers: [
                                                            BlocProvider.value(
                                                                value: BlocProvider.of<
                                                                        profile_cubit
                                                                        .ProfileCubit>(
                                                                    context)),
                                                            BlocProvider.value(
                                                                value: BlocProvider
                                                                    .of<NocCubit>(
                                                                        context)),
                                                          ],
                                                          child:
                                                              SelectAddressBottomSheet(
                                                            loanNumber: state
                                                                .loanNumber,
                                                          )));
                                            } else {
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder: (_) =>
                                                      MultiBlocProvider(
                                                          providers: [
                                                            BlocProvider.value(
                                                                value: BlocProvider.of<
                                                                    locate_us_cubit
                                                                        .LocateUsCubit>(
                                                                    context)),
                                                            BlocProvider.value(
                                                                value: BlocProvider
                                                                    .of<NocCubit>(
                                                                        context)),
                                                          ],
                                                          child:
                                                              PincodeStateCityBottomsheet(
                                                            loanNumber: state
                                                                .loanNumber,
                                                          )));
                                            }
                                          }
                                        },
                                        child: Text(
                                          getString(lblUpdate),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: setColorBasedOnTheme(
                                                    context: context,
                                                    lightColor: AppColors
                                                        .secondaryLight,
                                                    darkColor: AppColors
                                                        .secondaryLight5),
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.v),
                              Text(
                                state.addressType ?? "",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                state.address is PermanentAddr
                                    ? "${state.address.fullAddress}, ${state.address.city}, ${state.address.state}, ${state.address.postalCode}"
                                    : " ${state.address.address}",
                                style: Theme.of(context).textTheme.labelSmall,
                              )
                            ],
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
                );
              }
              if (state is LoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Container();
            },
          ),
        ),
      ),
      floatingActionButton: BlocBuilder<NocCubit, NocState>(
        builder: (context, state) {
          if ((state is GetNocDetailsSuccessState &&
                  state.response.data != null &&
                  state.response.data?.nocStatus == null &&
                  state.response.data?.netSettlementAmt == null &&
                  !nocDetailsReq.containsRc &&
                  (DateTime.tryParse(state.response.data?.endDate ??
                                  DateTime.now().toIso8601String()) ??
                              DateTime.now())
                          .difference(DateTime.now())
                          .inDays <=
                      30) ||
              (state is PreferredMethodState) ||
              state is SelectedPrefferedAddressState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0.v),
                  child: Column(
                    children: [
                      if (state is SelectedPrefferedAddressState &&
                          state.address is Branch)
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.v),
                              color: setColorBasedOnTheme(
                                  context: context,
                                  lightColor: Colors.white,
                                  darkColor: AppColors.cardDark)),
                          child: Padding(
                            padding: EdgeInsets.all(16.0.v),
                            child: Text(
                              getString(noteNocValidity),
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ),
                        ),
                      SizedBox(height: 12.v),
                      MfCustomButton(
                        onPressed: () {
                          if (state is SelectedPrefferedAddressState) {
                            String? address;
                            String? flag;
                            if (state.address is Branch) {
                              address = nocDeliveryAddress.Branch.value;
                              flag = DeliveryFlags.branch.value;
                            } else if (state.address is PermanentAddr) {
                              if (state.addressType ==
                                  getString(lblPermanentAddress)) {
                                flag = DeliveryFlags.permanent.value;
                                address=nocDeliveryAddress.Permanent.value;
                              } else if (state.addressType ==
                                  getString(lblCurrentAccount)) {
                                flag = DeliveryFlags.current.value;
                                address=nocDeliveryAddress.Communication.value;
                              }
                            }
                            context.read<NocCubit>().saveDeliveryResponse(
                                SaveDeliveryReq(
                                    contractNumber: state.loanNumber,
                                    flag: flag ?? '',
                                    address: address ?? ""),
                                state.address);
                            return;
                          }
                          if (state is PreferredMethodState) {
                            if (state.preferredMethod ==
                                PreferredMethod.address) {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (_) => MultiBlocProvider(
                                          providers: [
                                            BlocProvider.value(
                                                value: BlocProvider.of<
                                                    profile_cubit
                                                    .ProfileCubit>(context)),
                                            BlocProvider.value(
                                                value:
                                                    BlocProvider.of<NocCubit>(
                                                        context)),
                                          ],
                                          child: SelectAddressBottomSheet(
                                            loanNumber: state.loanNumber,
                                          )));
                            } else {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (_) => MultiBlocProvider(
                                          providers: [
                                            BlocProvider.value(
                                                value: BlocProvider.of<
                                                    locate_us_cubit
                                                    .LocateUsCubit>(context)),
                                            BlocProvider.value(
                                                value:
                                                    BlocProvider.of<NocCubit>(
                                                        context)),
                                          ],
                                          child: PincodeStateCityBottomsheet(
                                            loanNumber: state.loanNumber,
                                          )));
                            }
                          }
                        },
                        text: getString(labelNOCFeatureSubmit),
                        outlineBorderButton: false,
                        isDisabled: false,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Container();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void showRateUsPopup(BuildContext context, String featureType) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => di<rate_us.RateUsCubit>(),
          child: RateUsDialogBox(
            featureType,
            onTap: (
              BuildContext dialogContex,
            ) {
              dissmissDialg(dialogContex, context);
            },
          ),
        );
      },
    );
  }

  void dissmissDialg(BuildContext dialogContex, BuildContext context) {
    Navigator.of(dialogContex).pop();
    toastForSuccessMessage(
        context: context,
        msg: getString(labelThankForYourFeedback),
        bottomPadding: MediaQuery.of(context).size.height * 0.80);
  }
}
