import 'package:core/config/string_resource/strings.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:product_details/data/models/active_loan_detail_response.dart';

// ignore_for_file: must_be_immutable
class BankDetailsWidgetPage extends StatefulWidget {
  BankDetailsWidgetPage(this.bankDetails, {super.key});

  BasicBankDetails bankDetails;

  @override
  BankDetailsWidgetPageState createState() => BankDetailsWidgetPageState();
}

class BankDetailsWidgetPageState extends State<BankDetailsWidgetPage>
    with AutomaticKeepAliveClientMixin<BankDetailsWidgetPage> {
  int length = 3;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Brightness brightness = Theme.of(context).brightness;
    return Container(
      child: _buildLastTransactions(context, brightness),
    );
  }

  Widget _buildLastTransactions(BuildContext context, Brightness brightness) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildCoApplicantName(
                    context,
                    coApplicantName: getString(msgMandateStatusProductDetail),
                    applicantName: widget.bankDetails.mandateStatus.toString(),
                  ),
                ),
                Expanded(
                  child: _buildCoApplicantName(
                    context,
                    coApplicantName: getString(bankHolderNameProductDetail),
                    applicantName:
                        widget.bankDetails.bankAccHolderName.toString(),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 17.v,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getString(bankNameProductDetail),
                          style: Theme.of(context).textTheme.bodyMedium),
                      SizedBox(height: 2.v),
                      Text(widget.bankDetails.bankName.toString(),
                          style: Theme.of(context).textTheme.labelMedium),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getString(msgBankAccountNumberProductDetail),
                          style: Theme.of(context).textTheme.bodyMedium),
                      SizedBox(height: 1.v),
                      Text(widget.bankDetails.bankAccNo.toString(),
                          style: Theme.of(context).textTheme.labelMedium),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 17.v,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getString(msgBranchNameProductDetail),
                          style: Theme.of(context).textTheme.bodyMedium),
                      SizedBox(height: 1.v),
                      Text(widget.bankDetails.branchName.toString(),
                          style: Theme.of(context).textTheme.labelMedium),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getString(umrnNumaberProductDetail),
                          style: Theme.of(context).textTheme.bodyMedium),
                      SizedBox(height: 2.v),
                      Text(widget.bankDetails.umrnNo.toString(),
                          style: Theme.of(context).textTheme.labelMedium),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 17.v,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getString(frequencyProductDetail),
                          style: Theme.of(context).textTheme.bodyMedium),
                      SizedBox(height: 1.v),
                      Text(widget.bankDetails.frequency.toString(),
                          style: Theme.of(context).textTheme.labelMedium),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCoApplicantName(
    BuildContext context, {
    required String coApplicantName,
    required String applicantName,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(coApplicantName, style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(height: 2.v),
        Text(applicantName, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}
