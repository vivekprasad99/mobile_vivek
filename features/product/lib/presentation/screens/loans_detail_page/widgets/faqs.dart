import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/app_dimens.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../data/models/product_feature_response.dart';

class FAQs extends StatelessWidget {
  const FAQs(this.faqs, {super.key});

  final List<Faq> faqs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 10.h),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8.h)),
      child: Align(
        alignment: Alignment.topLeft,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: faqs.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: Column(
                children: [
                  ExpansionTile(
                    collapsedIconColor: Theme.of(context).highlightColor,
                    iconColor: Theme.of(context).highlightColor,
                    tilePadding: EdgeInsets.zero,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text(
                              faqs[index].title.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 31.h, left: 12),
                              child: Flexible(
                                  child: Html(
                                      data: faqs[index].description.toString(),
                                      style: {
                                    "p": Style(
                                        padding: HtmlPaddings.zero,
                                        margin: Margins.zero),
                                    "body": Style(
                                        padding: HtmlPaddings.zero,
                                        margin: Margins.zero,
                                        fontSize:
                                            FontSize(AppDimens.labelSmall),
                                        fontFamily: "Karla",
                                        fontWeight: FontWeight.w400,
                                        color: setColorBasedOnTheme(
                                            context: context,
                                            lightColor: AppColors.textLight,
                                            darkColor: AppColors.white))
                                  })),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (faqs.length - 1 > index)
                    Divider(
                      thickness: 1,
                      height: 2.adaptSize,
                      indent: 12.adaptSize,
                      color: setColorBasedOnTheme(
                          context: context,
                          lightColor: AppColors.primaryLight6,
                          darkColor: AppColors.shadowDark),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
