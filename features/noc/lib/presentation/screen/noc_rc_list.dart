import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:noc/config/routes/route.dart';
import 'package:noc/data/models/gc_validate_req.dart';
import 'package:noc/data/models/get_loan_list_req.dart';
import 'package:noc/data/models/noc_details_req.dart';
import 'package:noc/presentation/cubit/noc_cubit.dart';
import 'package:noc/presentation/widgets/noc_list_item.dart';

class RCList extends StatefulWidget {
  // final String selectQuery;
  const RCList({
    super.key,
  });

  @override
  State<RCList> createState() => _RCListState();
}

class _RCListState extends State<RCList> {
  @override
  void initState() {
    // context.read<NocCubit>().selectQuery(widget.selectQuery);
    GetLoanListReq request = GetLoanListReq(ucic: getUCIC());
    context.read<NocCubit>().getLoansList(request);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        context: context,
        title: getString(lblNOCFeatureRcUpdate),
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          }
        },
      ),
      body: MFGradientBackground(
        child: BlocBuilder<NocCubit, NocState>(
          buildWhen: (context, state) {
            return state is GetLoansListSuccessState;
          },
          builder: (context, state) {
            if (state is LoadingState) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: Center(
                    child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                  strokeWidth: 2,
                )),
              );
            }
            if (state is GetLoansListSuccessState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NocListDropdown(
                  //   initialValue: widget.selectQuery,
                  // ),
                  // SizedBox(height: 16.v),
                  Text(getString(selectNOCFeatureLoan),
                      style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 8.v),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) {
                        return Opacity(
                          opacity: 0.5,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 7.0.v),
                          ),
                        );
                      },
                      itemCount: state.rcUpdateLoans?.length ?? 0,
                      itemBuilder: (context, index) {
                        if (state.vehicleLoans?[index] != null) {
                          return NocListItem(
                            loanData: state.rcUpdateLoans![index],
                            query: "",
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  )
                ],
              );
            }
            return Container();
          },
        ),
      ),
      floatingActionButton: BlocConsumer<NocCubit, NocState>(
        listener: (context, state) {
          if (state is GreenChannelLoading) {
            showLoaderDialog(context, getString(lblNocLoading));
          }
          if (state is GreenChannelValidationSuccessState) {
            Navigator.of(context, rootNavigator: true).pop();
            if (state.response.code == AppConst.codeFailure) {
              toastForFailureMessage(
                  context: context, msg: getString(msgNocMsgSomethingWentWrong));
            }
            if (state.response.data?.errorCodes == null ||
                state.response.data!.errorCodes!.isEmpty) {
              context.pushNamed(
                Routes.nocDetails.name,
                extra: NocDetailsReq(
                    loanNumber: state.data.loanAccountNumber,
                    ucic: state.data.ucic,
                    productCategory: state.data.productCategory,
                    productName: state.data.productName,
                    endDate: state.data.endDate?.toIso8601String(),
                    mobileNumber: state.data.mobileNumber,
                    lob: state.data.lob,
                    sourceSystem: state.data.sourceSystem,
                    nocStatus: state.data.nocStatus,
                    containsRc: state.response.data!.errorCodes!
                        .map((e) => e.errorCode)
                        .toList()
                        .contains("7")),
              );
            } else if (state.response.data!.errorCodes!
                    .map((e) => e.errorCode)
                    .toList()
                    .contains("2") ||
                state.response.data!.errorCodes!
                    .map((e) => e.errorCode)
                    .toList()
                    .contains("8") ||
                state.response.data!.errorCodes!
                    .map((e) => e.errorCode)
                    .toList()
                    .contains("9") ||
                state.response.data!.errorCodes!
                    .map((e) => e.errorCode)
                    .toList()
                    .contains("10") ||
                state.response.data!.errorCodes!
                    .map((e) => e.errorCode)
                    .toList()
                    .contains("11") ||
                state.response.data!.errorCodes!
                    .map((e) => e.errorCode)
                    .toList()
                    .contains("12") ||
                state.response.data!.errorCodes!
                    .map((e) => e.errorCode)
                    .toList()
                    .contains("18") ||
                state.response.data!.errorCodes!
                    .map((e) => e.errorCode)
                    .toList()
                    .contains("13") ||
                state.response.data!.errorCodes!
                    .map((e) => e.errorCode)
                    .toList()
                    .contains("14") ||
                state.response.data!.errorCodes!
                    .map((e) => e.errorCode)
                    .toList()
                    .contains("16") ||
                state.response.data!.errorCodes!
                    .map((e) => e.errorCode)
                    .toList()
                    .contains("17")) {
              context.pushNamed(
                Routes.visitBranch.name,
              );
            } else {
              context.pushNamed(
                Routes.nocDetails.name,
                extra: NocDetailsReq(
                    loanNumber: state.data.loanAccountNumber,
                    ucic: state.data.ucic,
                    productCategory: state.data.productCategory,
                    productName: state.data.productName,
                    endDate: state.data.endDate?.toIso8601String(),
                    mobileNumber: state.data.mobileNumber,
                    lob: state.data.lob,
                    sourceSystem: state.data.sourceSystem,
                    nocStatus: state.data.nocStatus,
                    containsRc: state.response.data!.errorCodes!
                        .map((e) => e.errorCode)
                        .toList()
                        .contains("7")),
              );
            }
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: BlocBuilder<NocCubit, NocState>(
              builder: (context, queryState) {
                return MfCustomButton(
                  text: getString(lblNocProceed),
                  outlineBorderButton: false,
                  isDisabled:
                      state is! SelectNocItem || (state.loanData == null),
                  onPressed: () {
                    if (state is SelectNocItem && state.loanData != null) {
                      if (state.loanData?.dpd != null &&
                          state.loanData!.dpd! > 30) {
                        context.pushNamed(Routes.visitBranch.name);
                      } else {
                        context.read<NocCubit>().greenChannelValidationtails(
                            GcValidateReq(
                                loanAccountNumber:
                                    state.loanData?.loanAccountNumber),
                            state.loanData!);
                      }
                    }
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
