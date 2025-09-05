import 'package:common/features/home/data/models/custom_offer_model.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/Strings.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';

class LoanOfferDetail extends StatefulWidget {
  const LoanOfferDetail({super.key, required this.customOfferResponse});

  final CustomOfferModel customOfferResponse;

  @override
  State<LoanOfferDetail> createState() => _LoanOfferDetailState();
}

class _LoanOfferDetailState extends State<LoanOfferDetail> {
  VerticalDivider divider = const VerticalDivider(
    color: Colors.grey,
    thickness: 1,
    indent: 5,
    endIndent: 5,
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66.v,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: setColorBasedOnTheme(
          context: context,
          lightColor: AppColors.primaryLight6,
          darkColor: AppColors.shadowDark,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildDetailColumn(
                getString(lblPreApprovedOfferLoanAmount),
                "₹ ${widget.customOfferResponse.loanAmount ?? ''}",
                context,
              ),
            ),
            divider,
            Visibility(
              visible: widget.customOfferResponse.emi != '' &&
                  widget.customOfferResponse.emi != null,
              child: Expanded(
                child: _buildDetailColumn(
                  getString(lblPreApprovedOfferMonthlyEMI),
                  "₹ ${widget.customOfferResponse.emi ?? ''}",
                  context,
                ),
              ),
            ),
            Visibility(
              visible: widget.customOfferResponse.emi != '' &&
                  widget.customOfferResponse.emi != null,
              child: divider,
            ),
            Expanded(
              child: _buildDetailColumn(
                getString(lblPreApprovedOfferTenure),
                " ${widget.customOfferResponse.tenure ?? ''} months",
                context,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Column _buildDetailColumn(String title, String value, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Center(
        child: Text(title,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontWeight: FontWeight.w400)),
      ),
      const SizedBox(height: 3.0),
      Center(child: Text(value, style: Theme.of(context).textTheme.titleSmall)),
    ],
  );
}
