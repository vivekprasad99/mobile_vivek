import 'package:core/config/string_resource/strings.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:product_details/data/models/active_loan_detail_response.dart';

// ignore_for_file: must_be_immutable
class BasicDetailsWidgetPage extends StatefulWidget {
  BasicDetailsWidgetPage(this.basicCustomerDetails, {super.key});

  BasicCustomerDetails basicCustomerDetails;

  @override
  BasicDetailsWidgetPageState createState() => BasicDetailsWidgetPageState();
}

class BasicDetailsWidgetPageState extends State<BasicDetailsWidgetPage>
    with AutomaticKeepAliveClientMixin<BasicDetailsWidgetPage> {
  int length = 3;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Brightness brightness = Theme.of(context).brightness;
    return Container(
      child: _buildLastTransactions(
          context, brightness, widget.basicCustomerDetails),
    );
  }

  Widget _buildLastTransactions(BuildContext context, Brightness brightness,
      BasicCustomerDetails basicCustomerDetails) {
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
                      coApplicantName: getString(coCustNameProductDetail),
                      applicantName:
                          widget.basicCustomerDetails.customerName.toString(),
                    ),
                  ),
                  Expanded(
                    child: _buildCoApplicantName(
                      context,
                      coApplicantName: getString(coAppliNameProductDetail),
                      applicantName: widget.basicCustomerDetails.coApplicantName
                          .toString(),
                    ),
                  )
                ],
              ),
              SizedBox(height: 17.v,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(getString(guarantorNameProductDetail),
                            style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(height: 2.v),
                        Text(
                            widget.basicCustomerDetails.guarantorName
                                .toString(),
                            style: Theme.of(context).textTheme.labelMedium),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(getString(branchNameProductDetail),
                            style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(height: 1.v),
                        Text(widget.basicCustomerDetails.branch.toString(),
                            style: Theme.of(context).textTheme.labelMedium),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 17.v,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(getString(executiveNameProductDetail),
                            style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(height: 1.v),
                        Text(
                            widget.basicCustomerDetails.executiveName
                                .toString(),
                            style: Theme.of(context).textTheme.labelMedium),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(getString(executiveNoProductDetail),
                            style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(height: 2.v),
                        Text(
                            widget.basicCustomerDetails.executiveNumber
                                .toString(),
                            style: Theme.of(context).textTheme.labelMedium),
                      ],
                    ),
                  )
                ],
              )
            ],
          )),
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
        Text(applicantName, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
