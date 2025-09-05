import 'package:common/features/home/data/models/custom_offer_model.dart';
import 'package:common/features/home/data/models/pre_approved_offer_response.dart';
import 'package:common/features/home/presentation/screens/preaApproved/offer_details_screen.dart';
import 'package:core/config/network/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:core/utils/size_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:common/config/routes/route.dart' as common;

class OfferBanner extends StatefulWidget {
  const OfferBanner({super.key, required this.offer, required this.offerSpecs});

  final OfferDetail offer;
  final CustomOfferModel offerSpecs;

  @override
  State<OfferBanner> createState() => _OfferBannerState();
}

class _OfferBannerState extends State<OfferBanner> {
  @override
  Widget build(BuildContext context) {
    String desc = parseHtmlString(widget.offer.subHeader.toString());
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          common.Routes.preapprovedOfferDetails.name,
          extra: OfferDetailPageArguments(
            offerDetail: widget.offer,
            offerSpecs: widget.offerSpecs,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8.h),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 180.h,
                      child: Text(
                        widget.offer.header?.first.toString() ?? "",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                    ),
                    SizedBox(height: 3.v),
                    SizedBox(
                      width: 180.h,
                      child: Text(
                        desc,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                    SizedBox(height: 12.v),
                    InkWell(
                      child: Row(
                        children: [
                          Text(
                            widget.offer.buttonName ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: Theme.of(context).highlightColor,
                                ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Theme.of(context).highlightColor,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 5.h),
                (widget.offer.image == null || widget.offer.image!.isEmpty)
                    ? const SizedBox.shrink()
                    : Expanded(
                        child: Image.network(
                          widget.offer.image!,
                          headers: getCMSImageHeader(),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String parseHtmlString(String htmlString) {
  var document = html_parser.parse(htmlString);
  return document.body?.text ?? '';
}
