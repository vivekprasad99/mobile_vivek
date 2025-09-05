import 'package:core/config/network/network_utils.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/extensions/string.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:product/config/routes/route.dart';
import 'package:product/data/models/product_feature_response.dart';
import 'package:common/features/search/data/model/search_response.dart';

class ProductsList extends StatefulWidget {
  const ProductsList(this.productFeaturte, this.index, {super.key});

  final ProductFeature productFeaturte;
  final int index;

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  bool isFrame1Visible = true;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        collapsedIconColor: Theme.of(context).highlightColor,
        iconColor: Theme.of(context).highlightColor,
        initiallyExpanded: true,
        childrenPadding: EdgeInsets.zero,
        dense: true,
        collapsedShape: const ContinuousRectangleBorder(),
        title: Text(widget.productFeaturte.productTitle.toString(),
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Theme.of(context).primaryColor)),
        children: <Widget>[
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.5,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: List<Widget>.generate(
                widget.productFeaturte.types?.length ?? 0, (index) {
              return (widget.productFeaturte.types?[index].typeTitle
                          ?.toLowerCase() !=
                      "mutual funds")
                  ? InkWell(
                      borderRadius: BorderRadius.circular(8.h),
                      highlightColor: Theme.of(context).highlightColor,
                      onTap: () {
                        context.pushNamed(
                            Routes.productFeaturesOneTabContainerScreen.name,
                            extra: LoansTabBarArguments(
                                    loanTypeData:
                                        widget.productFeaturte.types?[index])
                                .toJson());
                      },
                      child: Ink(
                        height: 620.adaptSize,
                        width: 156.adaptSize,
                        child: Card(
                          elevation: 0.0,
                          color: Theme.of(context).cardColor,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Image.network(
                                    headers: getCMSImageHeader(),
                                    widget.productFeaturte.types?[index]
                                            .loanImage ??
                                        '',
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  widget.productFeaturte.types?[index].typeTitle
                                          ?.toTitleCase() ??
                                      '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                  : const SizedBox();
            }),
          ),
        ],
      ),
    );
  }
}
