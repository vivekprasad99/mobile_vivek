import 'package:ach/config/routes/route.dart';
import 'package:ach/data/models/get_mandate_res.dart';
import 'package:ach/data/models/update_mandate_info.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/custom_elevated_button.dart';
import 'package:core/config/string_resource/Strings.dart';
import 'package:core/config/widgets/action_buttons/sticky_floating_action_button.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';
import 'package:service_ticket/features/data/models/service_request_response.dart';
import 'package:service_ticket/features/data/models/sr_request.dart';
import 'package:service_ticket/features/presentation/cubit/service_request_cubit.dart';
import 'package:service_ticket/features/presentation/cubit/service_request_state.dart';

import '../../../config/ach_const.dart';
import '../../../config/source.dart';
import '../../../data/models/fetch_applicant_name_req.dart';
import '../../../data/models/fetch_bank_account_req.dart';
import '../../../data/models/get_ach_loans_response.dart';
import '../../../data/models/update_mandate_reason_resp.dart';
import '../../cubit/ach_cubit.dart';
import 'package:service_request/config/routes/route.dart' as service_ticket;

class UpdateMandateScreen extends StatefulWidget {
  final LoanData loanData;
  final String applicantName;
  final MandateData mandateData;

  const UpdateMandateScreen(
      {super.key, required this.loanData, required this.applicantName, required this.mandateData});

  @override
  State<UpdateMandateScreen> createState() => _UpdateMandateScreenState();
}

class _UpdateMandateScreenState extends State<UpdateMandateScreen> {
  final TextEditingController otherReason = TextEditingController();
  ValueNotifier<bool> isValidated = ValueNotifier<bool>(false);
  @override
  void initState() {
    context.read<AchCubit>().getUpdateMandateReason();
    super.initState();
  }

  @override
  void dispose() {
    otherReason.dispose();
    super.dispose();
  }

  UpdateMandateReason? selectedVal;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: const StickyFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: customAppbar(
          context: context,
          title: getString(lblUpdateMandate), onPressed: () {
            context.pop();
        },
          actions: [HelpCommonWidget(categoryval: HelpConstantData.categoryMandateRegistration,subCategoryval: HelpConstantData.subCategoryMandateUpdate)],
        ),
        body: MFGradientBackground(
          horizontalPadding: 16,
          verticalPadding: 16,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getString(msgUpdateReason),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      MultiBlocListener(listeners: [
                        BlocListener<AchCubit, AchState>(listener: (context, state) {
                          if (state is FetchBankAccountSuccessState) {
                            if (state.response.code == AppConst.codeSuccess) {
                              var updateMandateInfo = UpdateMandateInfo(mandateData: widget.mandateData, reason: selectedVal?.value);
                              if(state.response.data != null && state.response.data!.isNotEmpty){
                                context.pushNamed(Routes.addedBanksScreen.name, extra: {"loanData": state.loanItem, "bankData": state.response.data, "updateMandateInfo" : updateMandateInfo});
                              } else {
                                context.pushNamed(Routes.selectBankScreen.name, extra: {"loanData": state.loanItem, "selectedApplicant": "", "updateMandateInfo" : updateMandateInfo, "source": Source()});
                              }
                            } else {
                              toastForFailureMessage(
                                  context: context,
                                  msg: getString(msgSomethingWentWrong));
                            }
                          } else if (state is FetchBankAccountFailureState) {
                            toastForFailureMessage(
                                context: context,
                                msg: getString(msgSomethingWentWrong));
                          } else if (state is FetchBankAccountFailureState) {
                            toastForFailureMessage(
                                context: context,
                                msg: getFailureMessage(state.failure),
                                bottomPadding: 4.v);
                          } else if (state is FetchApplicantNameSuccessState) {
                            if (state.response.code == AppConst.codeSuccess) {
                              var loanData = state.loanData;
                              loanData?.applicantName =
                                  state.response.data?.applicantName ?? "";
                              loanData?.coApplicantName =
                                  state.response.data?.coApplicantName ?? "";
                              BlocProvider.of<AchCubit>(context).fetchBankAccount(
                                  FetchBankAccountRequest(
                                      loanAccountNumber:
                                      loanData?.loanAccountNumber ?? "",
                                      ucic: loanData?.ucic ?? "",
                                      cif: loanData?.cif ?? "", superAppId: getSuperAppId(), source: AppConst.source),
                                  loanData);
                            } else {
                              toastForFailureMessage(
                                  context: context,
                                  msg: getString(msgSomethingWentWrong));
                            }
                          } else if (state is FetchApplicantNameFailureState) {
                            toastForFailureMessage(
                                context: context,
                                msg: getString(msgSomethingWentWrong));
                          } else if (state is LoadingDialogState) {
                            if (state.isloading) {
                              showLoaderDialog(context, getString(lblMandateLoading));
                            } else {
                              Navigator.of(context, rootNavigator: true).pop();
                            }
                          }
                        }),
                        BlocListener<ServiceRequestCubit,ServiceRequestState>(listener: (context, state) {
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
                                  showSnackBar(
                                      context: context, message: state.response.message ?? getString(msgSomethingWentWrong));
                                }
                              }
                            } else {
                              displayAlertSingleAction(
                                  context, state.response.message ?? "",
                                  btnLbl: getString(lblOk), btnTap: () {
                                context.pop();
                              });
                            }
                          } else if (state is ServiceRequestFailureState) {
                            toastForFailureMessage(context: context, msg: getFailureMessage(state.error));
                          } else if (state is ServiceRequestLoadingState) {
                            if (state.isLoading) {
                              showLoaderDialog(context, getString(lblMandateLoading));
                            } else {
                              Navigator.of(context, rootNavigator: true).pop();
                            }
                          }
                        })
                      ], child: BlocBuilder<AchCubit, AchState>(
                          buildWhen: (previous, current) {
                            return current is GetUpdateMandeReasonSuccessState;
                          }, builder: (context, state) {
                        if (state is LoadingState) {
                          return Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ));
                        }
                        if (state is GetUpdateMandeReasonSuccessState) {
                          return Column(
                            children: [
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.response.data?.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) =>
                                    BlocBuilder<AchCubit, AchState>(
                                      builder: (context, state2) {
                                        return GestureDetector(
                                          onTap: () {
                                            selectedVal = state.response.data?[index];
                                            context
                                                .read<AchCubit>()
                                                .selectUpdateReason(
                                                state.response.data![index]);
                                          },
                                          child: Row(
                                            children: [
                                              Radio(
                                                activeColor:
                                                Theme.of(context).primaryColor,
                                                value: state.response.data![index],
                                                groupValue: selectedVal,
                                                onChanged: (val) {
                                                  selectedVal =
                                                  state.response.data![index];
                                                  context
                                                      .read<AchCubit>()
                                                      .selectUpdateReason(state
                                                      .response.data![index]);
                                                },
                                              ),
                                              Text(
                                                state.response.data![index].value ??
                                                    "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium
                                                    ?.copyWith(
                                                    fontWeight: FontWeight.w500),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                              ),
                              BlocBuilder<AchCubit, AchState>(
                                builder: (context, state) {
                                  if (selectedVal != null &&
                                      selectedVal?.otherIssue == true) {
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
                                          borderRadius:
                                          BorderRadius.circular(4.h),
                                          borderSide: BorderSide(
                                            color: setColorBasedOnTheme(
                                                context: context,
                                                lightColor:
                                                AppColors.primaryLight3,
                                                darkColor:
                                                AppColors.secondaryLight5),
                                            width: 1,
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(4.h),
                                          borderSide: BorderSide(
                                            color: setColorBasedOnTheme(
                                                context: context,
                                                lightColor:
                                                AppColors.primaryLight3,
                                                darkColor:
                                                AppColors.secondaryLight5),
                                            width: 1,
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(4.h),
                                          borderSide: BorderSide(
                                            color: setColorBasedOnTheme(
                                                context: context,
                                                lightColor:
                                                AppColors.primaryLight3,
                                                darkColor:
                                                AppColors.secondaryLight5),
                                            width: 1,
                                          ),
                                        ),
                                        helperStyle: Theme.of(context)
                                            .textTheme
                                            .labelSmall,
                                        hintStyle:
                                        Theme.of(context).textTheme.bodyLarge,
                                        helperText: getString(
                                            lblThisWillLogServiceReqTic),
                                        hintText:
                                        getString(lblEnterReasonMandatory),
                                      ),
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
                      }))
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: BlocBuilder<AchCubit, AchState>(
                  builder: (context, state) {
                    return ValueListenableBuilder(
                        valueListenable: isValidated,
                        builder: (context, bool isValid, child) {
                          return CustomElevatedButton(
                            text: getString(lblProceed),
                            buttonTextStyle: (selectedVal != null && selectedVal?.otherIssue == false) ? Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppColors.white) :
                            (isValid && selectedVal?.otherIssue == true)
                                ? Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppColors.white)
                                : Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                color: Theme.of(context)
                                    .unselectedWidgetColor),
                            buttonStyle: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.h),
                                ),
                                backgroundColor: (selectedVal != null && selectedVal?.otherIssue == false) ? Theme.of(context).highlightColor
                                    : (isValid && selectedVal?.otherIssue == true)
                                    ? Theme.of(context).highlightColor
                                    : Theme.of(context).disabledColor),
                            onPressed: selectedVal == null
                                ? null
                                : () {
                              if (selectedVal != null && selectedVal!.otherIssue! && isValid) {
                                // context.read<AchCubit>().generateSR(
                                //     GenerateSrRequest(
                                //         caseType: AchConst.caseTypeUpdateEMandate,
                                //         mobileNumber: getPhoneNumber(),
                                //         category: AchConst.srCategoryAchMandate,
                                //         subCategory: AchConst.srSubCategoryAchMandate,
                                //         inAppNotification: "0",
                                //         channel: AchConst.srChannelAchMandate,
                                //         lob: widget.loanData.lob,
                                //         productName: widget.loanData.productName,
                                //         srType:AchConst.srRequestTypeAchMandate,
                                //         customerName: widget.applicantName,
                                //         productCategory: widget.loanData.productCategory,
                                //         remarks: otherReason.text),
                                //     AchConst.srUpdateMandate);
                                var request = SRRequest(
                                    caseType: AchConst.caseTypeUpdateEMandate,
                                    customerId: getUCIC(),
                                    lob:widget.loanData.lob,
                                    mobileNumber: getPhoneNumber(),
                                    productName:widget.loanData.productName,
                                    category: AchConst.srCategoryAchMandate,
                                    subCategory: AchConst.srSubCategoryAchMandate,
                                    channel: AchConst.srChannelAchMandate,
                                    remarks: otherReason.text,
                                    customerName: getUserName(),
                                    description: "N/A",
                                    srType: AchConst.srRequestTypeAchMandate,
                                    productCategory: widget.loanData.productCategory,
                                    contractId: widget.loanData.loanAccountNumber,
                                    sourceSystem: widget.loanData.sourceSystem);

                                context.read<ServiceRequestCubit>().generateServiceRequest(request);
                              } else {
                                BlocProvider.of<AchCubit>(context)
                                    .fetchApplicantName(FetchApplicantNameReq(
                                    loanNumber: widget.loanData.loanAccountNumber ?? "",
                                    ucic: widget.loanData.ucic ?? "",
                                    cif: widget.loanData.cif ?? "",
                                    sourceSystem: widget.loanData.sourceSystem ?? "", superAppId: getSuperAppId(), source: AppConst.source), widget.loanData);
                              }
                            },
                          );
                        });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
