import 'package:core/config/config.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/custom_image_view.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/action_buttons/sticky_floating_action_button.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/common_widgets/mf_custom_drop_down.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:help/features/data/models/help_model.dart';
import 'package:help/features/data/models/help_request.dart';
import 'package:help/features/presentation/cubit/help_cubit.dart';
import 'package:help/features/presentation/email_footer.dart';

// ignore_for_file: must_be_immutable
class HelpScreen extends StatelessWidget {
  HelpCatSub helpCatSub;

  HelpScreen({required this.helpCatSub, super.key});

  @override
  Widget build(BuildContext context) {
    HelpRequest helpRequest = HelpRequest(category: "faq", language: "en");
    context.read<HelpCubit>().loadFaqs(
        request: helpRequest,
        subCategory: helpCatSub.subCategory,
        categoryName: helpCatSub.category);
    return Scaffold(
      floatingActionButton: const StickyFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomSheet: emailFooter(context),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: customAppbar(
        context: context,
        title: getString(lblHelpFaq),
        onPressed: () {
          context.pop();
        },
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Center(
              child: BlocBuilder<HelpCubit, HelpState>(
                builder: (context, state) {
                  if (state is LoadedState) {
                    List<DropdownMenuEntry<String>> dropdownMenuEntries =
                        state.subType.map((e) {
                      return DropdownMenuEntry<String>(
                        value: e.productSubType ?? "",
                        label: e.productSubType ?? "",
                      );
                    }).toList();
                    return Container(
                      height: 50,
                      padding: const EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: setColorBasedOnTheme(
                          context: context,
                          lightColor: AppColors.primaryLight6,
                          darkColor: AppColors.shadowDark,
                        ),
                      ),
                      child: MfCustomDropDown(
                        width: 160,
                        title: getString(lblGoToCategory),
                        titleTextStyle:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 12.adaptSize,
                                  fontWeight: FontWeight.w400,
                                ),
                        dropdownMenuEntries: dropdownMenuEntries,
                        onSelected: (value) {
                          context.read<HelpCubit>().selectSubType(value ?? "");
                          helpCatSub.subCategory = value ?? "";
                          HelpRequest helpRequest =
                              HelpRequest(category: "faq", language: "en");
                          context.read<HelpCubit>().loadFaqs(
                              request: helpRequest,
                              subCategory: helpCatSub.subCategory,
                              categoryName: helpCatSub.category);
                        },
                      ),
                    );
                  }
                  return  const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<HelpCubit, HelpState>(
        builder: (context, state) {
          if (state is LoadingState && state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LoadedState) {
            if (state.faqs.isEmpty) {
              return  Center(child: Text(getString(lblNoFaq)));
            }
            return MFGradientBackground(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BlocBuilder<HelpCubit, HelpState>(
                          builder: (context, state) {
                            if (state is LoadedState) {
                              String? sub;
                              sub = state.productSubTypeName.first;

                              return Text(sub,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w600));
                            }

                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(8.h)),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.faqs.length,
                          itemBuilder: (context, index) {
                            final faq = state.faqs[index];
                            return Theme(
                              data: Theme.of(context)
                                  .copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                collapsedIconColor: Theme.of(context).highlightColor,
                                iconColor: Theme.of(context).highlightColor,
                                tilePadding: EdgeInsets.zero,
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 12.v, left: 12),
                                        child: Text(
                                          faq.question.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.w600),
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
                                              data: faq.answer.toString(),
                                              style: {
                                                "body": Style(
                                                    fontSize: FontSize(
                                                        AppDimens.labelSmall),
                                                    fontFamily: "Karla",
                                                    fontWeight: FontWeight.w400,
                                                    color: setColorBasedOnTheme(
                                                        context: context,
                                                        lightColor:
                                                            AppColors.textLight,
                                                        darkColor:
                                                            AppColors.white))
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is ErrorState) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return  _buildEmptyScreen(context);
        },
      ),
    );
  }

  _buildEmptyScreen(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: MFGradientBackground(
        horizontalPadding: 0,
        verticalPadding: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomImageView(
                imagePath: ImageConstant.vector,
                height: 50.adaptSize,
                width: 50.adaptSize,
                color: setColorBasedOnTheme(
                    context: context,
                    lightColor: AppColors.primaryLight,
                    darkColor: AppColors.backgroundDarkGradient6)),
            SizedBox(
              width: 15.v,
            ),
            Text(
                getString(lblNoFaq),
                style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
