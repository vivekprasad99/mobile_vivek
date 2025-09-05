import 'package:ach/config/ach_util.dart';
import 'package:ach/config/routes/route.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/custom_elevated_button.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';

import '../../../data/models/fetch_bank_accoun_response.dart';
import '../../../data/models/get_ach_loans_response.dart';
import '../../../data/models/get_bank_list_resp.dart';
import '../../../data/models/get_cms_bank_list_resp.dart';
import '../../../data/models/update_mandate_info.dart';
import '../../cubit/ach_cubit.dart';
import '../widgets/verification_widget.dart';

class BankVerifyOptionsScreen extends StatefulWidget {
  final BankData bank;
  final LoanData loanData;
  final String selectedApplicant;
  final UpdateMandateInfo updateMandateInfo;

  const BankVerifyOptionsScreen({super.key, required this.bank, required this.loanData, required this.selectedApplicant, required this.updateMandateInfo});

  @override
  State<BankVerifyOptionsScreen> createState() =>
      _BankVerifyOptionsScreenState();
}

class _BankVerifyOptionsScreenState extends State<BankVerifyOptionsScreen> {
  int visibleBanks = 2;
  VerificationOption? selectedVerificationOption;
  List<VerificationOption>? verificationOptions;
  String source = MandateSource.cams.name;
  List<CMSBank>? masterBankData;

  @override
  void initState() {
    super.initState();
    context.read<AchCubit>().getCMSBankList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: customAppbar(
          context: context,
          title: getString(lblMandateCreateMandate),
          onPressed: () {
            Navigator.pop(context);
          },
          actions: [HelpCommonWidget(categoryval: HelpConstantData.categoryMandateRegistration,subCategoryval: HelpConstantData.subCategoryVerification)],
        ),
        body: MFGradientBackground(
          horizontalPadding: 14.h,
          verticalPadding: 12.v,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: _buildActiveLoansFour(context),
                ),
              ),
              _buildContinue(context: context, selectedBankCode: widget.bank.bankCode ?? "",selectedBankName: widget.bank.bankName ?? "", loanData: widget.loanData),
              SizedBox(height: 20.v,)
            ],
          ),
        ),
      ),
     );
  }

  Widget _buildActiveLoansFour(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 5.v,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(3.h)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3.h),
            child: const LinearProgressIndicator(
              value: 0.2,
              backgroundColor: AppColors.primaryLight5,
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppColors.primaryLight3),
            ),
          ),
        ),
        SizedBox(height: 20.v),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8.h),
              border: null),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.bank.bankName ?? "",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              SizedBox(height: 7.v),
              Text(
                formatAccountNumber(widget.bank.bankAccountNo ?? ""),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
        SizedBox(height: 20.v),
        SizedBox(
          child: BlocConsumer<AchCubit, AchState>(
            listener: (context, state) {
              if (state is FilterBankList) {
                verificationOptions = state.bank.verificationOption;
                context.read<AchCubit>().selectNewBank(state.bank);
              } else if (state is GetBankListSuccessState) {
                if(state.response.code == AppConst.codeSuccess){
                  source = state.response.data?.source ?? MandateSource.cams.name;
                }
              } else if(state is GetCMSBankListSuccessState){
                if(state.response.statusCode == AppConst.codeSuccess){
                  masterBankData = state.response.data?.banks;
                  context.read<AchCubit>().getVerificationOption(widget.bank, masterBankData);
                } else {
                  toastForFailureMessage(context: context, msg: state.response.message ?? "");
                }
              } else if(state is GetCMSBankListFailureState) {
                toastForFailureMessage(context: context, msg: getFailureMessage(state.failure));
              }
            },
            builder: (context, state) {
              if (state is LoadingState) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                );
              }
              return const VerificationOptionWidget();
            },
          ),
        ),
      ],
    );
  }


  /// Section Widget
  Widget _buildContinue(
      {required BuildContext context,
      required LoanData loanData,
      required String selectedBankCode,
      required String selectedBankName}) {
    return BlocConsumer<AchCubit, AchState>(
      buildWhen: (context, state) {
        return state is SelectNewBankVerificationOtpionState;
      },
      listener: (context, state) {
        if (state is SelectNewBankVerificationOtpionState) {
          selectedVerificationOption = state.option;
        }
      },
      builder: (context, state) {
        return CustomElevatedButton(
          text: getString(lblMandateContinue),
          onPressed: () {
            if (selectedVerificationOption?.optionId == VerificationMode.upi.value) {
              var bankData = Bank(bankCode: widget.bank.bankCode, bankName: widget.bank.bankName);
              context.pushNamed(Routes.upiScreen.name, extra: {
                "loanData": loanData,
                "selectedBank": bankData,
                "verificationMode": selectedVerificationOption,
                "selectedApplicant": widget.selectedApplicant,
                "updateMandateInfo": widget.updateMandateInfo
              });
            } else {
              context.pushNamed(Routes.updateCusBankDetail.name, extra: {
                "loanData": loanData,
                "bankData": widget.bank,
                "verificationMode": selectedVerificationOption,
                "selectedApplicant": widget.selectedApplicant,
                "updateMandateInfo": widget.updateMandateInfo,
                "source": source
              });
            }
          },
          buttonStyle: ElevatedButton.styleFrom(
              backgroundColor: selectedVerificationOption != null
                  ? Theme.of(context).highlightColor
                  : Theme.of(context).disabledColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.h),
              )),
          buttonTextStyle: selectedVerificationOption != null
              ? Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.white)
              : Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).unselectedWidgetColor),
        );
      },
    );
  }
}
