import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/custom_elevated_button.dart';
import 'package:core/config/resources/custom_outlined_button.dart';
import 'package:core/config/string_resource/Strings.dart';
import 'package:core/config/widgets/action_buttons/sticky_floating_action_button.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_appbar.dart';
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
import 'package:ach/config/routes/route.dart';
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';
import 'package:service_ticket/features/data/models/service_request_response.dart';
import 'package:service_ticket/features/data/models/sr_request.dart';
import 'package:service_ticket/features/presentation/cubit/service_request_cubit.dart';
import 'package:service_ticket/features/presentation/cubit/service_request_state.dart';
import '../../../config/ach_const.dart';
import '../../../data/models/get_ach_loans_response.dart';
import '../../../data/models/get_cancel_mandate_response.dart';
import '../../../data/models/get_mandate_res.dart';
import '../../cubit/ach_cubit.dart';
import 'package:service_request/config/routes/route.dart' as service_ticket;

class CancelMandateScreen extends StatefulWidget {
  final LoanData loanData;
  final String applicantName;
  final MandateData mandateData;

  const CancelMandateScreen(
      {super.key, required this.loanData, required this.applicantName, required this.mandateData});

  @override
  State<CancelMandateScreen> createState() => _CancelMandateScreenState();
}

class _CancelMandateScreenState extends State<CancelMandateScreen> {
  final TextEditingController otherReason = TextEditingController();
  BuildContext? _context;
  @override
  void initState() {
    context.read<AchCubit>().getCancelMandateReason();
    super.initState();
  }

  @override
  void dispose() {
    otherReason.dispose();
    super.dispose();
  }

  ValueNotifier<bool> isValidated = ValueNotifier<bool>(false);

  CancelReason? selectedVal;
  String? currentSrType;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: const StickyFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: customAppbar(
          context: context,
          title: getString(lblCancelMandate), onPressed: () {
            context.pop();
        },
          actions: [HelpCommonWidget(categoryval: HelpConstantData.categoryMandateRegistration,subCategoryval: HelpConstantData.subCategoryMandateCancel)],
        ),
        body: MFGradientBackground(
          horizontalPadding: 16,
          verticalPadding: 16,
          child: MultiBlocListener( listeners: [
                BlocListener<ServiceRequestCubit, ServiceRequestState>(listener: (context, state) {
                  if (state is ServiceRequestSuccessState) {
                    if (state.response.code == AppConst.codeSuccess && state.response.data != null) {
                      ServiceRequestResponse serviceRequestResponse = state.response;
                      if (serviceRequestResponse.data?.isNewTicket == true) {
                        context.goNamed(service_ticket.Routes.serviceRequestBureauRaised.name,
                            extra: state.response);
                      }
                      else {
                        List<String>? serviceRequestList = state.response.data?.oldTickets ?? [];
                        if (serviceRequestList.isNotEmpty) {
                          ServiceRequestResponse serviceRequestResponse = state.response;
                          context.pushNamed(service_ticket.Routes.serviceRequestBureauExist.name,
                              extra: serviceRequestResponse);
                        }
                        else {
                          toastForFailureMessage(context: context, msg: state.response.message ?? getString(msgSomethingWentWrong));
                          context.pop();
                        }
                      }
                    } else {
                      displayAlertSingleAction(
                          context, state.response.message ?? "",
                          btnLbl: getString(lblOk), btnTap: () {
                        context.pop();
                      });
                      context.pop();
                    }
                  } else if (state is ServiceRequestFailureState) {
                    toastForFailureMessage(context: context, msg: getFailureMessage(state.error));
                    context.pop();
                  } else if (state is ServiceRequestLoadingState) {
                    if (state.isLoading) {
                      showLoaderDialog(context, getString(lblMandateLoading));
                    } else {
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                  }
                })
              ],
              child:  Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getString(msgCancelReason),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      BlocBuilder<AchCubit, AchState>(buildWhen: (previous, current) {
                        return current is GetCancelMandateReasonSuccessState;
                      }, builder: (context, state) {
                        if (state is LoadingState) {
                          return Center(child: CircularProgressIndicator( color: Theme.of(context).primaryColor,));
                        }
                        if (state is GetCancelMandateReasonSuccessState) {
                          return Column(
                            children: [
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.response.data?.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) =>
                                    BlocBuilder<AchCubit, AchState>(
                                  builder: (context, state2) {
                                    return Row(
                                      children: [
                                        Radio(
                                          value: state.response.data?[index],
                                          groupValue: selectedVal,
                                          activeColor: Theme.of(context).primaryColor,
                                          onChanged: (val) {
                                            selectedVal = state.response.data?[index];
                                            context
                                                .read<AchCubit>()
                                                .selectCancelReason(
                                                    state.response.data![index]);
                                          },
                                        ),
                                        Text(
                                          state.response.data?[index]
                                                  .cancelReasonTitle ??
                                              "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium
                                              ?.copyWith(fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                              BlocBuilder<AchCubit, AchState>(
                                builder: (context, state) {
                                  if (selectedVal != null &&
                                      selectedVal?.cancelReasonDesc?.isEmpty == true) {
                                    return TextField(
                                      onChanged: (val) {
                                        if (val.isNotEmpty) {
                                          isValidated.value = true;
                                        } else {
                                          isValidated.value = false;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        border: UnderlineInputBorder(
                                          borderRadius: BorderRadius.circular(4.h),
                                          borderSide: BorderSide(
                                            color: setColorBasedOnTheme(
                                                context: context,
                                                lightColor: AppColors.primaryLight3,
                                                darkColor: AppColors.secondaryLight5),
                                            width: 1,
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderRadius: BorderRadius.circular(4.h),
                                          borderSide: BorderSide(
                                            color: setColorBasedOnTheme(
                                                context: context,
                                                lightColor: AppColors.primaryLight3,
                                                darkColor: AppColors.secondaryLight5),
                                            width: 1,
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderRadius: BorderRadius.circular(4.h),
                                          borderSide: BorderSide(
                                            color: setColorBasedOnTheme(
                                                context: context,
                                                lightColor: AppColors.primaryLight3,
                                                darkColor: AppColors.secondaryLight5),
                                            width: 1,
                                          ),
                                        ),
                                        helperStyle:
                                            Theme.of(context).textTheme.labelSmall,
                                        hintStyle:
                                            Theme.of(context).textTheme.bodyLarge,
                                        helperText:
                                            getString(lblThisWillLogServiceReqTic),
                                        hintText: getString(lblEnterReasonMandatory),
                                      ),
                                      // maxLines: 3,
                                      controller: otherReason,
                                    );
                                  }
                                  return Container();
                                },
                              ),
                            ],
                          );
                        }
                        return Container();
                      }),
                    ],
                                ),
                              ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: setColorBasedOnTheme(
                                context: context,
                                lightColor: Colors.white,
                                darkColor: AppColors.cardDark),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline,
                                    color: AppColors.yellowIconColor),
                                const SizedBox(
                                  width: 8,
                                ),
                                Flexible(
                                    child: Text(
                                      getString(msgCancelNote),
                                    ))
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        BlocBuilder<AchCubit, AchState>(
                          builder: (context, state) {
                            return ValueListenableBuilder(
                              valueListenable: isValidated,
                              builder: (context, bool isValid, child) {
                                return CustomElevatedButton(
                                  text: getString(lblProceed),
                                  buttonTextStyle: selectedVal == null ||
                                      selectedVal?.cancelReasonDesc == null
                                      ? isValid
                                      ? Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: AppColors.white)
                                      : Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                      color: Theme.of(context)
                                          .unselectedWidgetColor)
                                      : Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: AppColors.white),
                                  buttonStyle: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.h),
                                      ),
                                      backgroundColor: selectedVal == null ||
                                          selectedVal?.cancelReasonDesc == null
                                          ? isValid
                                          ? Theme.of(context).highlightColor
                                          : Theme.of(context).disabledColor
                                          : Theme.of(context).highlightColor),
                                  onPressed: selectedVal == null
                                      ? null
                                      : () {
                                    if (selectedVal != null &&
                                        selectedVal?.cancelReasonDesc == null &&
                                        isValid) {
                                      var request = SRRequest(
                                          caseType: AchConst.caseTypeCancelEMandate,
                                          customerId: getUCIC(),
                                          lob:widget.loanData.lob,
                                          customerName: getUserName(),
                                          mobileNumber: getPhoneNumber(),
                                          productName:widget.loanData.productName,
                                          category: AchConst.srCategoryAchMandate,
                                          subCategory: AchConst.srSubCategoryAchMandate,
                                          channel: AchConst.srChannelAchMandate,
                                          srType: AchConst.srRequestTypeAchMandate,
                                          productCategory: widget.loanData.productCategory,
                                          description: otherReason.text,
                                          contractId: widget.loanData.loanAccountNumber,
                                          sourceSystem: widget.loanData.sourceSystem,
                                          remarks: otherReason.text);

                                      context.read<ServiceRequestCubit>().generateServiceRequest(request);
                                    } else {
                                      showModalBottomSheet(
                                        context: _context!,
                                        builder: (_) => BlocProvider(
                                          create: (context) => di<AchCubit>(),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    getString(lblAreYouSure),
                                                    style: Theme.of(context).textTheme.titleLarge,
                                                  ),
                                                  const SizedBox(
                                                    height: 32,
                                                  ),
                                                  Text(
                                                    selectedVal?.cancelReasonDesc ?? "",
                                                    style: Theme.of(context).textTheme.labelSmall,
                                                  ),
                                                  const SizedBox(
                                                    height: 24,
                                                  ),
                                                  Column(
                                                    children: [
                                                      _getPreButton( selectedVal, context, widget.loanData, widget.applicantName),
                                                      const SizedBox(height: 8,),
                                                      _getPostButton( selectedVal, context, widget.loanData, widget.applicantName, widget.mandateData)
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}

String _getPreLabel(CancelReason? selectedVal) {
  if (selectedVal?.canHold == false && selectedVal?.canUpdate == false) {
    return getString(lblBack);
  } else {
    return getString(lblCancelMandate);
  }
}

String _getPostLabel(CancelReason? selectedVal) {
  if (selectedVal?.canHold == true) {
    return getString(lblHoldMandate);
  } else if (selectedVal?.canUpdate == true) {
    return getString(lblUpdateMandate);
  } else {
    return getString(lblCancelMandate);
  }
}

Widget _getPreButton(CancelReason? selectedVal,
    BuildContext context, LoanData loanData, String selectedApplicant) {
  if (selectedVal?.canHold == false && selectedVal?.canUpdate == false) {
    return CustomOutlinedButton(
      onPressed: () {
        context.pop();
      },
      text: _getPreLabel(selectedVal),
      buttonStyle: ElevatedButton.styleFrom(
        side: BorderSide(color: Theme.of(context).highlightColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h),
        ),
      ),
      buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).highlightColor,
          ),
    );
  } else {
      return CustomOutlinedButton(
        onPressed: () {
          var request = SRRequest(
              caseType: AchConst.caseTypeCancelEMandate,
              customerId: getUCIC(),
              lob:loanData.lob,
              mobileNumber: getPhoneNumber(),
              productName:loanData.productName,
              category: AchConst.srCategoryAchMandate,
              subCategory: AchConst.srSubCategoryAchMandate,
              channel: AchConst.srChannelAchMandate,
              customerName: getUserName(),
              description: selectedVal?.cancelReasonTitle,
              remarks: selectedVal?.cancelReasonTitle,
              srType: AchConst.srRequestTypeAchMandate,
              productCategory: loanData.productCategory,
              contractId: loanData.loanAccountNumber,
              sourceSystem: loanData.sourceSystem);

          context.read<ServiceRequestCubit>().generateServiceRequest(request);
        },
        text: _getPreLabel(selectedVal),
        buttonStyle: ElevatedButton.styleFrom(
          side: BorderSide(color: Theme.of(context).highlightColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.h),
          ),
        ),
        buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).highlightColor,
            ),
      );
    }
}

Widget _getPostButton(CancelReason? selectedVal,
    BuildContext context, LoanData loanData, String selectedApplicant, MandateData mandateData) {
  if (selectedVal?.canHold == true) {
      return CustomElevatedButton(
          onPressed: () {
            var request = SRRequest(
                caseType: AchConst.caseTypeHoldEMandate,
                customerId: getUCIC(),
                lob:loanData.lob,
                mobileNumber: getPhoneNumber(),
                productName:loanData.productName,
                category: AchConst.srCategoryAchMandate,
                 customerName: getUserName(),
                subCategory: AchConst.srSubCategoryAchMandate,
                channel: AchConst.srChannelAchMandate,
                srType: AchConst.srRequestTypeAchMandate,
                productCategory: loanData.productCategory,
                contractId: loanData.loanAccountNumber,
                sourceSystem: loanData.sourceSystem,
                description: selectedVal?.cancelReasonTitle,
                remarks: selectedVal?.cancelReasonTitle,);

            context.read<ServiceRequestCubit>().generateServiceRequest(request);
          },
          text: _getPostLabel(selectedVal),
          buttonStyle: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).highlightColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.h),
            ),
          ),
          buttonTextStyle: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.white));
  } else if (selectedVal?.canUpdate == true) {
      return CustomElevatedButton(
          onPressed: () async {
            context.pop();
            context.pushNamed(Routes.updateMadateScreen.name, extra: {"loanData": loanData, "applicantName": selectedApplicant, "mandateData": mandateData});
          },
          text: _getPostLabel(selectedVal),
          buttonStyle: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).highlightColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.h),
            ),
          ),
          buttonTextStyle: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.white));
  } else {
      return CustomOutlinedButton(
          onPressed: () {

            var request = SRRequest(
                caseType: AchConst.caseTypeCancelEMandate,
                customerId: getUCIC(),
                lob:loanData.lob,
                mobileNumber: getPhoneNumber(),
                productName:loanData.productName,
                customerName: getUserName(),
                category: AchConst.srCategoryAchMandate,
                subCategory: AchConst.srSubCategoryAchMandate,
                channel: AchConst.srChannelAchMandate,
                srType: AchConst.srRequestTypeAchMandate,
                productCategory: loanData.productCategory,
                contractId: loanData.loanAccountNumber,
                description: selectedVal?.cancelReasonTitle,
                sourceSystem: loanData.sourceSystem,
                remarks: selectedVal?.cancelReasonTitle,);

            context.read<ServiceRequestCubit>().generateServiceRequest(request);
          },
          text: _getPostLabel(selectedVal),
          buttonStyle: ElevatedButton.styleFrom(
            side: BorderSide(color: Theme.of(context).highlightColor),
            backgroundColor: Theme.of(context).highlightColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.h),
            ),
          ),
          buttonTextStyle: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.white));
  }
}
