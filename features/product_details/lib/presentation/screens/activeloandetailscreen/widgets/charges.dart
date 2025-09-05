import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:product_details/data/models/active_loan_detail_response.dart';
import 'package:product_details/utils/constants.dart';
import 'package:core/config/string_resource/strings.dart';


// ignore_for_file: must_be_immutable
class ChargesWidgetPage extends StatefulWidget {
  ChargesWidgetPage(this.basicChargeDetails, {super.key});

  BasicChargeDetails? basicChargeDetails;

  @override
  ActiveVehicleLoanDetailsWidgetemiPageState createState() =>
      ActiveVehicleLoanDetailsWidgetemiPageState();
}

class ActiveVehicleLoanDetailsWidgetemiPageState
    extends State<ChargesWidgetPage>
    with AutomaticKeepAliveClientMixin<ChargesWidgetPage> {
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
                      coApplicantName: getString(lblInterestChargeProductDetail),
                      applicantName: PaymentConstants.rupeeSymbol +
                          widget.basicChargeDetails!.additionalInterestCharges
                              .toString(),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(getString(lblRepossChargeProductDetail),
                            style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(height: 2.v),
                        Text(
                            PaymentConstants.rupeeSymbol +
                                widget.basicChargeDetails!.repossessionCharges
                                    .toString(),
                            style: Theme.of(context).textTheme.labelMedium),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 17.v,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildCoApplicantName(
                      context,
                      coApplicantName: getString(lblChequeReturnChargeProductDetail),
                      applicantName: PaymentConstants.rupeeSymbol +
                          widget.basicChargeDetails!.chequeReturnCharges
                              .toString(),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(getString(lblOtherChargeProductDetail),
                            style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(height: 1.v),
                        Text(
                            PaymentConstants.rupeeSymbol +
                                widget.basicChargeDetails!.otherCharges
                                    .toString(),
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
