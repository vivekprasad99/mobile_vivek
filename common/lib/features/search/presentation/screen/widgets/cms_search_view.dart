import 'package:common/features/search/data/model/search_response.dart';
import 'package:common/features/search/presentation/cubit/search_cubit.dart';
import 'package:common/features/search/presentation/screen/widgets/faq_search_results.dart';
import 'package:common/features/search/presentation/screen/widgets/text_highlighter.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CMSSearchViewWidget extends StatelessWidget {
  const CMSSearchViewWidget(
      {super.key, required this.state, required this.query});
  final GetSearchRouteSuccessState state;
  final String query;

  @override
  Widget build(BuildContext context) {
    return searchApiSuggestionWidget(context, state);
  }

  Widget searchApiSuggestionWidget(
      BuildContext context, GetSearchRouteSuccessState state,) {
    return SingleChildScrollView(
      child: state.isShowServices ?? false
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.servicesList.isNotEmpty)
                  cmsServicesView(context, state),
                if (state.productsList.isNotEmpty)
                  cmsProducsView(context, state),
                if (state.faqsList.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getString(lblSearchFAQs),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      FAQSearchResultsViewWidget(state: state)
                    ],
                  )
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.productsList.isNotEmpty)
                  cmsProducsView(context, state),
                if (state.servicesList.isNotEmpty)
                  cmsServicesView(context, state),
                if (state.faqsList.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getString(lblSearchFAQs),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      FAQSearchResultsViewWidget(state: state)
                    ],
                  )
              ],
            ),
    );
  }

  Padding cmsProducsView(
      BuildContext context, GetSearchRouteSuccessState state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              getString(lblSearchProducts),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Column(
              children: List.generate(
                state.productsList.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      if (state.productsList[index].screenRouter ==
                          "privacyPolicy") {
                        state.productsList[index].extra = true;
                      }
                      if((state.productsList[index].productSubType ?? "").isNotEmpty){
                      if (state.productsList[index].screenRouter ==
                          "productFeaturesOneTabContainerScreen") {
                        state.productsList[index].extra = LoansTabBarArguments(
                          isFromSearch: true,
                          productSubType:
                              state.productsList[index].productSubType,
                          productType: state.productsList[index].productType,
                        ).toJson();
                      }
                      }
                      context
                          .read<SearchCubit>()
                          .addSearch(state.productsList[index]);
                      context.read<SearchCubit>().getExistingRecentSearchList();
                      if (state.productsList[index].canPop ?? false) {
                        context.pushReplacementNamed(
                            state.productsList[index].screenRouter ?? "",
                            extra: state.productsList[index].extra);
                      } else {
                        context
                            .pushNamed(
                                state.productsList[index].screenRouter ?? "",
                                extra: state.productsList[index].extra)
                            .then((value) {
                          context.read<SearchCubit>().searchStateOnBack();
                        });
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TitleTextHighlighter(
                            text: state.productsList[index].title ?? "",
                            query: query),
                        Icon(
                          Icons.search,
                          color: setColorBasedOnTheme(
                              context: context,
                              lightColor: AppColors.primaryLight3,
                              darkColor: AppColors.white),
                          size: 15,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding cmsServicesView(
      BuildContext context, GetSearchRouteSuccessState state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              getString(lblSearchServices),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Column(
              children: List.generate(
                state.servicesList.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      context
                          .read<SearchCubit>()
                          .addSearch(state.servicesList[index]);
                      context.read<SearchCubit>().getExistingRecentSearchList();
                      if (state.servicesList[index].canPop ?? false) {
                        context.pushReplacementNamed(
                            state.servicesList[index].screenRouter ?? "",
                            extra: state.servicesList[index].extra);
                      } else {
                        context
                            .pushNamed(
                                state.servicesList[index].screenRouter ?? "",
                                extra: state.servicesList[index].extra)
                            .then((value) {
                          context.read<SearchCubit>().searchStateOnBack();
                        });
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TitleTextHighlighter(
                            text: state.servicesList[index].title ?? "",
                            query: query),
                        Icon(
                          Icons.search,
                          color: setColorBasedOnTheme(
                              context: context,
                              lightColor: AppColors.primaryLight3,
                              darkColor: AppColors.white),
                          size: 15,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
