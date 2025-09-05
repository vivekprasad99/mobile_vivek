import 'package:common/features/search/data/model/search_request.dart';
import 'package:common/features/search/presentation/cubit/search_cubit.dart';
import 'package:common/features/search/presentation/screen/widgets/text_highlighter.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ServicesViewBucketWidget extends StatelessWidget {
  const ServicesViewBucketWidget(
      {super.key, required this.query, required this.state,});

  final String query;
  final UpdateSearchSuggestionList state;

  @override
  Widget build(BuildContext context) {
    return servicesViewBucket(context, state);
  }

  Padding servicesViewBucket(
      BuildContext context, UpdateSearchSuggestionList state,) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Text(
              getString(lblSearchServices),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Column(
              children: List.generate(
                (state.servicesList ?? []).length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: GestureDetector(
                    onTap: () {
                      if ((state.servicesList?[index].screenRouter ?? "")
                          .isEmpty) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        context.read<SearchCubit>().getSearchRoute(
                            SearchRequest(
                                searchQuery: state.servicesList?[index].title,),);
                      } else {
                        context
                            .read<SearchCubit>()
                            .addSearch((state.servicesList ?? [])[index]);
                        context
                            .read<SearchCubit>()
                            .getExistingRecentSearchList();
                        if (state.servicesList?[index].canPop ?? false) {
                          context.pushReplacementNamed(
                              state.servicesList?[index].screenRouter ?? "",
                              extra: state.servicesList?[index].extra,);
                        } else {
                          context.pushNamed(
                              state.servicesList?[index].screenRouter ?? "",
                              extra: state.servicesList?[index].extra,);
                          context.read<SearchCubit>().searchStateOnBack();
                        }
                      }
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TitleTextHighlighter(
                              text: state.servicesList?[index].title ?? "",
                              query: query,),
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
          ),
        ],
      ),
    );
  }
}
