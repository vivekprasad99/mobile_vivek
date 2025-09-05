import 'package:ach/data/models/get_ach_loans_request.dart';
import 'package:ach/presentation/cubit/ach_cubit.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_refund/features/presentation/cubit/loan_refund_cubit.dart';
import '../widgets/refund_loan_item.dart';
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';

class RefundLoansList extends StatefulWidget {
  const RefundLoansList({super.key, this.appBarTitle});

  final String? appBarTitle;

  @override
  State<RefundLoansList> createState() => _RefundLoansListState();
}

class _RefundLoansListState extends State<RefundLoansList> {
  @override
  void initState() {
    GetAchLoansRequest request = GetAchLoansRequest(
        superAppId: getSuperAppId(),
        ucic: getUCIC(),
        filter: "Active",
        currentTimeStamp: getCurrentTimeStamp(),
        refundFlag: true);
    BlocProvider.of<LoanRefundCubit>(context).getLoanList(request: request);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: customAppbar(
              context: context,
              title: widget.appBarTitle == null
                  ? getString(lblRefund)
                  : getString(
                      lblRaiseFund,
                    ),
              onPressed: () {
                context.pop();
              },
              actions: [
               HelpCommonWidget(categoryval: HelpConstantData.categoryRefund,subCategoryval: HelpConstantData.categoryRefund,)
              ]),
          body: RefundLoanItem(
              widgetVisibility: widget.appBarTitle == null ? true : false),
          ),
    );
  }

  bool enableProceedButton(AchState state) {
    if (state is SelectedLoanItemState) {
      return true;
    }
    return false;
  }
}
