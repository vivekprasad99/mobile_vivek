import 'package:core/config/config.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:faq/features/data/models/faq_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
// ignore_for_file: must_be_immutable
class GeneralTab extends StatefulWidget {
  List<GeneralTypes>? generalType;

  GeneralTab(this.generalType, {super.key});

  @override
  State<GeneralTab> createState() => _GeneralTabState();
}

class _GeneralTabState extends State<GeneralTab> {
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: itemContainer());
  }

  Widget itemContainer() {
    return MFGradientBackground(
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.generalType?.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, indexGeneral) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, bottom: 8.0),
                    child: Text(
                        widget.generalType![indexGeneral].header.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600)),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(8.h)),
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            widget.generalType?[indexGeneral].faq?.length ?? 0,
                        itemBuilder: (context, indexFaq) {
                          return Column(
                            children: [
                              Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  collapsedIconColor: Theme.of(context).highlightColor,
                                  iconColor: Theme.of(context).highlightColor,
                                  tilePadding: EdgeInsets.zero,
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 12.v, left: 12),
                                          child: Text(
                                            widget.generalType?[indexGeneral]
                                                .faq?[indexFaq].question
                                                .toString() ?? "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontWeight:
                                                        FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 3.v, bottom: 3),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 297.h,
                                            margin: EdgeInsets.only(
                                                right: 31.h, left: 12),
                                            child: Html(
                                                data: widget
                                                        .generalType?[
                                                            indexGeneral]
                                                        .faq?[indexFaq]
                                                        .answer
                                                        .toString() ??
                                                    "",
                                                style: {
                                                  "body": Style(
                                                      fontSize: FontSize(
                                                          AppDimens.labelSmall),
                                                      fontFamily: "Karla",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          setColorBasedOnTheme(
                                                              context: context,
                                                              lightColor:
                                                                  AppColors
                                                                      .textLight,
                                                              darkColor:
                                                                  AppColors
                                                                      .white))
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if ((indexFaq + 1) !=
                                  widget.generalType![indexGeneral].faq!.length)
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 8.v, right: 8.v),
                                  child: const Divider(
                                    color: AppColors.sliderColor,
                                  ),
                                ),
                            ],
                          );
                        }),
                  ),
                  const SizedBox(
                    height: 12.0,
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
