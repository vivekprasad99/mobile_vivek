import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/app_dimens.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../../data/models/product_feature_response.dart';

class HowToApply extends StatefulWidget {
  const HowToApply(this.list, this.tabDetails, {super.key});

  final List<OverviewDetails> list;
  final TabDetails? tabDetails;

  @override
  State<HowToApply> createState() => _HowToApplyState();
}

class _HowToApplyState extends State<HowToApply> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: setColorBasedOnTheme(
                  context: context,
                  lightColor: Colors.white,
                  darkColor: AppColors.cardDark),
              borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: EdgeInsets.only(top: 12.h, left: 12.h, right: 16.h),
            child: ListView.separated(
              itemCount: widget.list.length,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: setColorBasedOnTheme(
                            context: context,
                            lightColor: AppColors.primaryLight6,
                            darkColor: AppColors.shadowDark),
                        child: Text(
                          "${index + 1}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 12),
                        ),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      ((index + 1) == widget.list.length)
                          ? const SizedBox()
                          : Container(
                              width: 1.5.h,
                              height: 50.v,
                              color: setColorBasedOnTheme(
                                  context: context,
                                  lightColor: AppColors.primaryLight6,
                                  darkColor: AppColors.shadowDark),
                            ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.list[index].title ?? '',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(
                          width: 250.h,
                          height: 70.v,
                          child: Html(
                              data: widget.list[index].description ?? '',
                              style: {
                                "p": Style(
                                    padding: HtmlPaddings.zero,
                                    margin: Margins.zero),
                                "body": Style(
                                    padding: HtmlPaddings.zero,
                                    margin: Margins.zero,
                                    fontSize: FontSize(AppDimens.labelSmall),
                                    fontFamily: "Karla",
                                    fontWeight: FontWeight.w400,
                                    color: setColorBasedOnTheme(
                                        context: context,
                                        lightColor: AppColors.textLight,
                                        darkColor: AppColors.white))
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              separatorBuilder: (BuildContext context, int index) =>
                  Container(),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          decoration: BoxDecoration(
              color: setColorBasedOnTheme(
                  context: context,
                  lightColor: Colors.white,
                  darkColor: AppColors.cardDark),
              borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber,
                  size: 16,
                  color: Color.fromRGBO(230, 134, 0, 1),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Text(
                    "${widget.tabDetails?.disclaimer}",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
