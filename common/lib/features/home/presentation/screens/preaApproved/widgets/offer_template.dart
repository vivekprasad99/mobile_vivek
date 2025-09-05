import 'package:common/features/home/data/models/pre_approved_offer_response.dart';
import 'package:common/features/home/presentation/screens/preaApproved/pre_approved_offer_banner_tab_widget.dart';
import 'package:core/config/network/network_utils.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';

class OfferTemplate extends StatelessWidget {
  const OfferTemplate(
      {super.key, required this.offersList, required this.offerTitle,});
  final OfferDetail offersList;
  final String offerTitle;

  @override
  Widget build(BuildContext context) {
    String desc = parseHtmlString(offersList.subHeader.toString());
    String offerhead = parseHtmlString(offerTitle.toString());

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(223, 122, 121, 0.83),
            Color.fromRGBO(255, 255, 255, 1),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (offersList.image == null || offersList.image!.isEmpty)
              ? const SizedBox.shrink()
              : SizedBox(
                width: double.infinity,
                  child: Image.network(
                    offersList.image!,
                    headers: getCMSImageHeader(),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox.shrink();
                    },
                  ),
                ),
          SizedBox(height: 12.h),
          Text(offerhead, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primaryLight)), 
          SizedBox(height: 8.h),
          Text(
            desc,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primaryLight),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
