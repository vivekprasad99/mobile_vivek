import 'package:core/config/string_resource/strings.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:product_details/data/models/active_loan_detail_response.dart';

// ignore_for_file: must_be_immutable
class AssetsDetailsWidgetPage extends StatefulWidget {
  AssetsDetailsWidgetPage(this.basicAssetDetails, {super.key});

  BasicAssetDetails? basicAssetDetails;

  @override
  BankDetailsWidgetPageState createState() => BankDetailsWidgetPageState();
}

class BankDetailsWidgetPageState extends State<AssetsDetailsWidgetPage>
    with AutomaticKeepAliveClientMixin<AssetsDetailsWidgetPage> {
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
    return widget.basicAssetDetails != null
        ? Align(
            alignment: Alignment.topLeft,
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildCoApplicantName(
                            context,
                            coApplicantName: getString(registrationNumberProductDetail),
                            applicantName: widget.basicAssetDetails
                                    ?.vehicleRegistrationNumber
                                    ?.toString() ??
                                "",
                          ),
                        ),
                        SizedBox(height: 17.v),
                        Expanded(
                          child: _buildCoApplicantName(
                            context,
                            coApplicantName: getString(vehicleNameProductDetail),
                            applicantName: widget.basicAssetDetails?.vehicleName
                                    .toString() ??
                                "",
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(getString(engineNumberProductDetail),
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              SizedBox(height: 2.v),
                              Text(
                                  widget.basicAssetDetails?.engineNumber
                                          .toString() ??
                                      "",
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(getString(chassisNumberProductDetail),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                              ),
                              SizedBox(height: 1.v),
                              Text(
                                  widget.basicAssetDetails?.chasisNumber
                                          .toString() ??
                                      "",
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                            ],
                          ),
                        )
                      ],
                    )

                  ],
                )),
          )
        : Container();
  }

  Widget _buildCoApplicantName(
    BuildContext context, {
    required String coApplicantName,
    required String applicantName,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(coApplicantName, style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(height: 2.v),
        Text(applicantName, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }

}
