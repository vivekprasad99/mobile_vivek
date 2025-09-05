import 'package:common/features/search/presentation/cubit/search_cubit.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/app_dimens.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';

class FAQSearchResultsViewWidget extends StatelessWidget {
  const FAQSearchResultsViewWidget({super.key, required this.state});

  final GetSearchRouteSuccessState state;

  @override
  Widget build(BuildContext context) {
    return showSearchFAQResults(state);
  }

  Widget showSearchFAQResults(GetSearchRouteSuccessState state) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: (state.faqsList).length,
        itemBuilder: (context, indexFaq) {
          if (state.faqsList[indexFaq].answer != null ||
              (state.faqsList[indexFaq].answer ?? "").isNotEmpty) {
            return Column(
              children: [
                Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ListTileTheme(
                    minVerticalPadding: 0.0,
                    contentPadding: EdgeInsets.zero,
                    child: ExpansionTile(
                      iconColor: Theme.of(context).primaryColor,
                      collapsedIconColor: Theme.of(context).primaryColor,
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: EdgeInsets.zero,
                      dense: true,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Text(
                                state.faqsList[indexFaq].faqQuestion.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ],
                      ),
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 5),
                              child: Html(
                                  data: state.faqsList[indexFaq].answer.toString(),
                                  style: {
                                    "body": Style(
                                        fontSize:
                                            FontSize(AppDimens.labelSmall),
                                        fontFamily: "Karla",
                                        fontWeight: FontWeight.w400,
                                        color: setColorBasedOnTheme(
                                            context: context,
                                            lightColor: AppColors.textLight,
                                            darkColor: AppColors.white,),),
                                  },),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(color: Theme.of(context).dividerColor,),
              ],
            );
          }
          return GestureDetector(
            onTap: () {
              if (state.faqsList[indexFaq].canPop ?? false) {
                context.pushReplacementNamed(
                    state.faqsList[indexFaq].screenRouter ?? "",);
              } else {
                context
                    .pushNamed(state.faqsList[indexFaq].screenRouter ?? "")
                    .then((value) {
                  context.read<SearchCubit>().searchStateOnBack();
                });
              }
            },
            child: ListTile(
              title: Text(
                state.faqsList[indexFaq].title ?? "",
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(fontWeight: FontWeight.w400),
              ),
            ),
          );
        },);
  }
}
