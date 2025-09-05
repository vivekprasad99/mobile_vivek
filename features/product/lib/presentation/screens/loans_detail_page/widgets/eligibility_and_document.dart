import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/app_dimens.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../data/models/product_feature_response.dart';

class EligibilityAndDocuments extends StatefulWidget {
  const EligibilityAndDocuments(this.tabDetails, {super.key});

  final TabDetails? tabDetails;

  @override
  State<EligibilityAndDocuments> createState() =>
      _EligibilityAndDocumentsState();
}

class _EligibilityAndDocumentsState extends State<EligibilityAndDocuments> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8.h)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(
                  widget.tabDetails?.description.toString() ?? '',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                ListView.separated(
                    itemCount: widget.tabDetails?.documents?.length ?? 0,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: setColorBasedOnTheme(
                            context: context,
                            lightColor: AppColors.primaryLight6,
                            darkColor: AppColors.shadowDark),
                      );
                    },
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 10.v),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.tabDetails?.documents?[index].title
                                      .toString() ??
                                  '',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                            ),
                            SizedBox(
                              height: widget.tabDetails?.documents?[index]
                                          .description !=
                                      null
                                  ? 2
                                  : 0,
                            ),
                            widget.tabDetails?.documents?[index].description !=
                                    null
                                ? Html(
                                    data: widget.tabDetails?.documents?[index]
                                            .description
                                            .toString() ??
                                        '',
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
                                      })
                                : Container(),
                          ],
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 80.v,
        )
      ],
    );
  }
}
