import 'package:core/utils/size_utils.dart';
import 'package:product/data/models/product_feature_response.dart';
import 'package:product/presentation/screens/loans_detail_page/widgets/eligibility_and_document.dart';
import 'package:product/presentation/screens/loans_detail_page/widgets/emi_calculator.dart';
import 'package:product/presentation/screens/loans_detail_page/widgets/faqs.dart';
import 'package:product/presentation/screens/loans_detail_page/widgets/how_to_apply.dart';
import 'package:product/presentation/screens/loans_detail_page/widgets/features_and_benefits.dart';

import 'package:flutter/material.dart';

class LoansDetailPage extends StatefulWidget {
  const LoansDetailPage(
      {required this.loanTab, this.position, this.categoryKey, super.key});

  final List<LoanTab>? loanTab;
  final int? position;
  final GlobalKey? categoryKey;

  @override
  LoansDetailPageState createState() => LoansDetailPageState();
}

class LoansDetailPageState extends State<LoansDetailPage>
    with AutomaticKeepAliveClientMixin<LoansDetailPage> {
  int activeIndex = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.loanTab != null)
          _loansTabBarDetailsView(
              context, widget.loanTab![widget.position ?? 0]),
      ],
    );
  }

  Widget _loansTabBarDetailsView(BuildContext context, LoanTab loanTab) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _loansTabBarWidgets(context, loanTab),
        const SizedBox(height: 8.0),
      ],
    );
  }

  Widget _loansTabBarWidgets(BuildContext context, LoanTab loanTab) {
    return Column(
      children: [
        Row(
          key: widget.categoryKey,
          children: [
            Text(
              loanTab.tabDetails?.title.toString() ?? '',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            )
          ],
        ),
        SizedBox(
          height: 10.v,
        ),
        loanTab.tabDetails?.featuresTitle != null &&
                loanTab.tabDetails?.featuresTitle?.isNotEmpty == true
            ? FeaturesAndBenefits(loanTab.tabDetails)
            : Container(),
        loanTab.tabDetails?.emiDetails != null
            ? EmiCalculator(loanTab.tabDetails?.emiDetails ?? EmiDetails())
            : Container(),
        loanTab.tabDetails?.faqs != null &&
                loanTab.tabDetails?.faqs?.isNotEmpty == true
            ? FAQs(loanTab.tabDetails?.faqs ?? [])
            : Container(),
        loanTab.tabDetails?.applySteps != null &&
                loanTab.tabDetails?.applySteps?.isNotEmpty == true
            ? HowToApply(
                loanTab.tabDetails?.applySteps ?? [], (widget.loanTab?[5].tabDetails))
            : Container(),
        loanTab.tabDetails?.documents != null &&
                loanTab.tabDetails?.documents?.isNotEmpty == true
            ? EligibilityAndDocuments(loanTab.tabDetails)
            : Container(),
      ],
    );
  }
}
