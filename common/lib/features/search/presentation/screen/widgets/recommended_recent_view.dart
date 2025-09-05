import 'package:common/features/search/presentation/cubit/search_cubit.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RecommendedRecentViewWidget extends StatelessWidget {
  const RecommendedRecentViewWidget({super.key, required this.state});

  final SearchRecentRecommendedState state;

  @override
  Widget build(BuildContext context) {
    return recommendedRecentSearchView(context, state);
  }

  SingleChildScrollView recommendedRecentSearchView(
      BuildContext context, SearchRecentRecommendedState state,) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if ((state.recentSearchList ?? []).isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        getString(lblRecent),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Column(
                        children: List.generate(
                          (state.recentSearchList ?? []).length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: GestureDetector(
                              onTap: () {
                                if (state.recentSearchList?[index].canPop ??
                                    false) {
                                  context.pushReplacementNamed(
                                      state.recentSearchList?[index]
                                              .screenRouter ??
                                          "",
                                      extra:
                                          state.recentSearchList?[index].extra,);
                                } else {
                                  context
                                      .pushNamed(
                                          state.recentSearchList?[index]
                                                  .screenRouter ??
                                              "",
                                          extra: state
                                              .recentSearchList?[index].extra,)
                                      .then((value) {
                                    if (context.mounted) {
                                      context
                                          .read<SearchCubit>()
                                          .searchStateOnBack();
                                    }
                                  });
                                }
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    state.recentSearchList?[index].title ?? "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(fontWeight: FontWeight.w400),
                                  ),
                                  Icon(
                                    Icons.search,
                                    color: setColorBasedOnTheme(
                                        context: context,
                                        lightColor: AppColors.primaryLight3,
                                        darkColor: AppColors.white,),
                                    size: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              if ((state.recentSearchList ?? []).isNotEmpty)
                Divider(
                  color: Theme.of(context).dividerColor,
                ),
              if ((state.recommendedList ?? []).isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.v,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        getString(lblSearchRecommended),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    Wrap(
                        children: List.generate(
                            (state.recommendedList ?? []).length,
                            (index) => GestureDetector(
                                  onTap: () {
                                    context.read<SearchCubit>().addSearch(
                                        (state.recommendedList ?? [])[index],);
                                    context
                                        .read<SearchCubit>()
                                        .getExistingRecentSearchList();
                                    if (state.recommendedList?[index].canPop ??
                                        false) {
                                      context.pushReplacementNamed(
                                          state.recommendedList?[index]
                                                  .screenRouter ??
                                              "",
                                          extra: state
                                              .recommendedList?[index].extra,);
                                    } else {
                                      context
                                          .pushNamed(
                                              state.recommendedList?[index]
                                                      .screenRouter ??
                                                  "",
                                              extra: state
                                                  .recommendedList?[index]
                                                  .extra,)
                                          .then((value) {
                                        context
                                            .read<SearchCubit>()
                                            .searchStateOnBack();
                                      });
                                    }
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 0, 10, 10,),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          border: Border.all(
                                              color: setColorBasedOnTheme(
                                                  context: context,
                                                  lightColor:
                                                      AppColors.secondaryLight,
                                                  darkColor: AppColors
                                                      .secondaryLight5,),),),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 16,),
                                      child: Text(
                                        state.recommendedList?[index].title ??
                                            "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                color: setColorBasedOnTheme(
                                                    context: context,
                                                    lightColor: AppColors
                                                        .secondaryLight,
                                                    darkColor: AppColors
                                                        .secondaryLight5,),),
                                      ),),
                                ),),),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
