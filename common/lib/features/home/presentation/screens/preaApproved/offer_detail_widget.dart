import 'package:common/features/home/data/models/custom_offer_model.dart';
import 'package:common/features/home/data/models/pre_approved_offer_response.dart';
import 'package:common/features/home/presentation/screens/preaApproved/widgets/eligibility_widget.dart';
import 'package:common/features/home/presentation/screens/preaApproved/widgets/feature_benefits_widget.dart';
import 'package:common/features/home/presentation/screens/preaApproved/widgets/loan_offer_detail.dart';
import 'package:flutter/material.dart';
import 'package:core/utils/size_utils.dart';

class OfferDetailsWidget extends StatefulWidget {
  const OfferDetailsWidget({
    super.key,
    required this.offerDetailTabs,
    this.position,
    this.categoryKey,
    this.customOfferResponse,
  });

  final List<OfferDetailTab> offerDetailTabs;
  final int? position;
  final GlobalKey? categoryKey;
  final CustomOfferModel? customOfferResponse;

  @override
  State<OfferDetailsWidget> createState() => OfferDetailsWidgetState();
}

class OfferDetailsWidgetState extends State<OfferDetailsWidget>
    with AutomaticKeepAliveClientMixin<OfferDetailsWidget> {
  int activeIndex = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      margin: const EdgeInsets.only(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _offersTabBarDetailsView(
            context,
            widget.offerDetailTabs[widget.position ?? 0],
          ),
        ],
      ),
    );
  }

  Widget _offersTabBarDetailsView(
    BuildContext context,
    OfferDetailTab offerDetailTabs,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _offersTabBarWidgets(context, offerDetailTabs),
        const SizedBox(height: 8.0),
      ],
    );
  }

  Widget _offersTabBarWidgets(
    BuildContext context,
    OfferDetailTab offerDetailTabs,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (offerDetailTabs.tabDetails?.featuresList?.isNotEmpty) ?? false
            ? (widget.customOfferResponse?.loanAmount != "" ||
                    (widget.customOfferResponse?.loanAmount ?? "").isNotEmpty)
                ? LoanOfferDetail(
                    customOfferResponse:
                        widget.customOfferResponse ?? CustomOfferModel(),
                  )
                : const SizedBox.shrink()
            : const SizedBox.shrink(),
        if (offerDetailTabs.tabDetails?.featuresList?.isNotEmpty == true)
          SizedBox(
            height: 16.v,
          ),
        if (offerDetailTabs.tabDetails?.title?.isNotEmpty == true)
          Text(
            offerDetailTabs.tabDetails?.title.toString() ?? '',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
          ),
        SizedBox(
          height: 10.v,
        ),
        offerDetailTabs.tabDetails?.featuresList?.isNotEmpty ?? false
            ? FeatureBenefitsWidget(
                offerTabDetails: offerDetailTabs.tabDetails,
              )
            : Container(),
        offerDetailTabs.tabDetails?.eligibilityList?.isNotEmpty ?? false
            ? OfferEligibility(
                offerTabDetails: offerDetailTabs.tabDetails,
              )
            : Container(),
      ],
    );
  }
}
