import 'package:core/config/string_resource/strings.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:product_details/data/models/active_loan_detail_response.dart';
import 'package:product_details/utils/date_time_convert.dart';

// ignore_for_file: must_be_immutable
class InsuranceDetailsWidgetPage extends StatefulWidget {
  InsuranceDetailsWidgetPage(this.insuranceDetails, {super.key});
  InsuranceDetails insuranceDetails;

  @override
  InsuranceDetailsWidgetPageState createState() =>
      InsuranceDetailsWidgetPageState();
}

class InsuranceDetailsWidgetPageState extends State<InsuranceDetailsWidgetPage>
    with AutomaticKeepAliveClientMixin<InsuranceDetailsWidgetPage> {
  int length = 3;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: _buildLastTransactions(context),
    );
  }

  Widget _buildLastTransactions(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildCoApplicantName(
                      context,
                      coApplicantName: getString(coAppliNameProductDetail),
                      name: widget.insuranceDetails.policyNo.toString(),
                    ),
                  ),
                  Expanded(
                    child: _buildCoApplicantName(
                      context,
                      coApplicantName: getString(policyTypeProductDetail),
                      name: widget.insuranceDetails.policyType.toString(),
                    ),
                  ),
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
                        Text(getString(periodInsuranceProductDetail),
                            style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(height: 2.v),
                        Text(
                            '${ConvertDateTime.convert(widget.insuranceDetails.policyStartDate.toString())}-${ConvertDateTime.convert(widget.insuranceDetails.policyExpiryDate.toString())}',
                            style: Theme.of(context).textTheme.labelMedium),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(getString(insuranceDateProductDetail),
                            style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(height: 1.v),
                        Text(
                            ConvertDateTime.convert(widget
                                .insuranceDetails.policyIssueDate
                                .toString()),
                            style: Theme.of(context).textTheme.labelMedium),
                      ],
                    ),
                  ),
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
                        Text(getString(amountInsuredProductDetail),
                            style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(height: 1.v),
                        Text(widget.insuranceDetails.insuredAmount.toString(),
                            style: Theme.of(context).textTheme.labelMedium),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(getString(totalPremiumMonthlyProductDetail),
                            style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(height: 2.v),
                        Text(widget.insuranceDetails.totalPremium.toString(),
                            style: Theme.of(context).textTheme.labelMedium),
                      ],
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }

  Widget _buildCoApplicantName(
    BuildContext context, {
    required String coApplicantName,
    required String name,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(coApplicantName, style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(height: 2.v),
        Text(name, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}
