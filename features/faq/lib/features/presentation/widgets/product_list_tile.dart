import 'package:core/utils/size_utils.dart';
import 'package:faq/config/routes/route.dart';
import 'package:faq/features/data/models/faq_response.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// ignore_for_file: must_be_immutable
class ProductListTile extends StatefulWidget {
  ProductListTile(this.productTypes, this.index, {super.key});

  ProductTypes productTypes;
  int index;

  @override
  State<ProductListTile> createState() => _ProductListTileState();
}

class _ProductListTileState extends State<ProductListTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          collapsedIconColor: Theme.of(context).highlightColor,
          iconColor: Theme.of(context).highlightColor,
          initiallyExpanded: true,
          childrenPadding: EdgeInsets.zero,

          collapsedShape: const ContinuousRectangleBorder(),
          title: Text(widget.productTypes.title.toString(),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Theme.of(context).primaryColor)),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: 2.6,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: List<Widget>.generate(
                    widget.productTypes.subTypes?.length ?? 0, (index) {
                  return GestureDetector(
                      onTap: () {
                        Map<String, dynamic> categories = {
                          'productTypes': widget.productTypes,
                          'index': index
                        };
                        context.pushNamed(Routes.productItemScreen.name,
                            extra: categories);
                      },
                      child: Container(
                        height: 620.adaptSize,
                        width: 156.adaptSize,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(
                            8.h,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: Image.network(
                                  widget.productTypes.subTypes?[index].image ??
                                      '',
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.productTypes.subTypes?[index].title ??
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
                      ));
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
