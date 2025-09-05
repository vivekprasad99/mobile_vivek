import 'package:ach/data/models/get_mandate_res.dart';
import 'package:ach/presentation/cubit/ach_cubit.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/action_buttons/sticky_floating_action_button.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';
import 'package:intl/intl.dart';
import '../../../config/ach_util.dart';
import '../../../config/routes/route.dart';
import '../../../data/models/get_ach_loans_response.dart';
import '../../../data/models/get_mandate_req.dart';

class MandatesDetails extends StatefulWidget {
  final LoanData loanData;
  const MandatesDetails({super.key, required this.loanData});

  @override
  State<MandatesDetails> createState() => _MandatesDetailsState();
}

class _MandatesDetailsState extends State<MandatesDetails> {

  @override
  void initState() {
    super.initState();
    GetMandateRequest request =
    GetMandateRequest(loanAccountNumber: widget.loanData.loanAccountNumber, sourceSystem: widget.loanData.sourceSystem, cif: widget.loanData.cif, ucic: getUCIC(), emiAmount: widget.loanData.installmentAmount.toString(), superAppId: getSuperAppId(), source: AppConst.source);
    BlocProvider.of<AchCubit>(context).getMandates(request);
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      floatingActionButton: const StickyFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: customAppbar(
          context: context, title: getString(titleMandateDetials), 
          onPressed: () {
            context.pop();
      }, actions: [HelpCommonWidget(categoryval: HelpConstantData.categoryMandateRegistration,subCategoryval: HelpConstantData.subCategoryMandateDetails)],),
      body: MFGradientBackground(
        horizontalPadding: 12,
        child: BlocConsumer<AchCubit, AchState>(
          listener: (context, state) {
            if (state is GetMandatesSuccessState) {
              if (state.response.code == AppConst.codeFailure) {
                toastForFailureMessage(context: context, msg: state.response.message ?? "", bottomPadding: 4.v);
              }
            } else if (state is GetMandatesFailureState) {
              toastForFailureMessage(context: context, msg: getFailureMessage(state.failure), bottomPadding: 4.v);
            }
          },
          builder: (context, state) {
            if (state is LoadingState && state.isloading) {
              return Center(
                  child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ));
            }
            if (state is GetMandatesSuccessState &&
                state.response.code == AppConst.codeSuccess &&
                state.response.data != null &&
                state.response.data!.isNotEmpty) {
              MandateData mandateData = state.response.data![0];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Container(
                            decoration: BoxDecoration(
                                color: setColorBasedOnTheme(
                                  context: context,
                                  lightColor: AppColors.primaryLight6,
                                  darkColor: AppColors.shadowDark,
                                ),
                                borderRadius: const BorderRadius.all(Radius.circular(8))),
                            child: getLoanImage(widget.loanData.productCategory ?? "", context),
                          ),
                          title: Text("${widget.loanData.productCategory ?? ""} | ${widget.loanData.productName ?? ""}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(letterSpacing: 0.5, fontWeight: FontWeight.w500)),
                          subtitle: Text(widget.loanData.vehicleRegistration ?? "",
                              style: Theme.of(context).textTheme.bodyMedium),
                          trailing: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: setColorBasedOnTheme(
                                  context: context,
                                  lightColor: AppColors.primaryLight6,
                                  darkColor: AppColors.shadowDark,
                                ),
                                borderRadius: BorderRadius.circular(4)),
                            child: Text(capitalizeFirstLetter(getMandateStatusLabel(mandateData.mandateStatus ?? "", widget.loanData.sourceSystem ?? "")),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: 11,
                                    color: setColorBasedOnTheme(
                                      context: context,
                                      lightColor: AppColors.textLight,
                                      darkColor: AppColors.backgroundLight5,
                                    ))),
                          ),
                        ),
                        Divider(
                          color: Theme.of(context).dividerColor,
                        ),
                        buildRow(context, getString(lblMandateStartDate), convertDate(mandateData.startDate ?? ""),
                            getString(lblEndDate), convertDate(mandateData.expiryDate ?? "")),
                        buildRow(context, getString(lblfrequency), mandateData.frequency ?? "",
                            getString(lblMandateBankHolderName), mandateData.accHolderName ?? ""),
                        buildRow(context, getString(lblBankName), mandateData.bankName ?? "", getString(lblBankNumber),
                            mandateData.bankAccountNo ?? ""),
                        buildRow(context, getString(lblMandateBranchName), mandateData.bankBranch ?? "",
                            getString(lblUmrnNumber), mandateData.umrnNo ?? ""),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Visibility(visible: !widget.loanData.loanStatus.toString().equalsIgnoreCase("Closed"), child: MfCustomButton(
                      onPressed: () {
                        context.pushNamed(Routes.updateMadateScreen.name, extra: {
                          "loanData": widget.loanData,
                          "applicantName": mandateData.accHolderName,
                          "mandateData": mandateData
                        });
                      },
                      text: getString(lblMandateUpdateMandate),
                      outlineBorderButton: true)),
                  const SizedBox(
                    height: 20,
                  ),
            Visibility(visible: !widget.loanData.loanStatus.toString().equalsIgnoreCase("Closed"), child: Center(
                    child: TextButton(
                      onPressed: () {
                        context.pushNamed(Routes.cancelMadateScreen.name, extra: {
                          "loanData": widget.loanData,
                          "applicantName": mandateData.accHolderName,
                          "mandateData": mandateData
                        });
                      },
                      child: Text(
                        getString(lblCancelMandate),
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).highlightColor),
                      ),
                    ),
                  ))
                ],
              );
            }
            return Center(
              child: Text(getString(msgMandateDetailNA),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).highlightColor)),
            );
          },
        ),
      ),
    );
  }

  Widget buildRow(BuildContext context, String title, String subtitle,
      String title2, String subtitle2) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(subtitle, style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title2,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(subtitle2, style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SvgPicture getLoanImage(String productCategory, BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    if (productCategory == LoanType.personalLoan.value) {
      return  SvgPicture.asset(brightness == Brightness.dark ? ImageConstant.imgPersonalLoanRupeeDark : ImageConstant.imgPersonalLoanRupeeLight);
    } else if (productCategory == LoanType.vehicleLoan.value) {
      return  SvgPicture.asset(brightness == Brightness.dark ? ImageConstant.imgVehicleLoanIconDark : ImageConstant.imgVehicleLoanIconLight);
    }
    return SvgPicture.asset(brightness == Brightness.dark ? ImageConstant.imgVehicleLoanIconDark : ImageConstant.imgVehicleLoanIconLight);
  }

  convertDate(String date) {
    if (date.isNotEmpty) {
      String originalDateString = date;
      DateTime dateTime = DateTime.parse(originalDateString);
      String formattedDateString = DateFormat('dd MMM yyyy').format(dateTime);
      return formattedDateString;
    }
    return date;
  }

  capitalizeFirstLetter(String status)
  {
    if (status.isEmpty) return status; // Return the string if it's empty
    return status[0].toUpperCase() + status.substring(1).toLowerCase();
  }
}