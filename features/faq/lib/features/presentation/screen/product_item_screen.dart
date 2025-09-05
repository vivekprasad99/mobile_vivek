import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/app_dimens.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/action_buttons/sticky_floating_action_button.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:faq/features/data/models/faq_response.dart';
import 'package:faq/features/presentation/cubit/faq_cubit.dart';
import 'package:faq/features/presentation/cubit/faq_state.dart';
import 'package:faq/features/presentation/widgets/common_widgets/email_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import '../widgets/custom_drop_down.dart';
// ignore_for_file: must_be_immutable
class ProductItemScreen extends StatefulWidget {
  ProductItemScreen(this.categories, {super.key});

  Map<String, dynamic> categories;

  @override
  State<ProductItemScreen> createState() => _ProductItemScreenState();
}

class _ProductItemScreenState extends State<ProductItemScreen> {
  SubTypes? selectedCategory;

  @override
  Widget build(BuildContext context) {
    ProductTypes productTypes = widget.categories['productTypes'];
    int selectedIndex = widget.categories['index'];
    SubTypes subTypes = productTypes.subTypes![selectedIndex];
    return SafeArea(
        child: Scaffold(
            floatingActionButton: const StickyFloatingActionButton(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomSheet: emailFooter(context),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              titleSpacing: 0,
              title: BlocBuilder<FAQCubit, FAQState>(
                builder: (context, state) {
                  String? title = state is DropDownState
                      ? state.category.screenTitle
                      : subTypes.screenTitle.toString();
                  return Text(title ?? "",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Theme.of(context).primaryColor));
                },
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomDropDown(
                        contentPadding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                        width: 120,
                        fillColor: setColorBasedOnTheme(
                          context: context,
                          lightColor: AppColors.primaryLight6,
                          darkColor: AppColors.shadowDark,
                        ),
                        themeData: Theme.of(context).copyWith(
                            canvasColor: setColorBasedOnTheme(
                          context: context,
                          lightColor: AppColors.primaryLight6,
                          darkColor: AppColors.shadowDark,
                        )),
                        borderDecoration: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.h),
                          borderSide: const BorderSide(
                            color: AppColors.transparent,
                          ),
                        ),
                        icon: Center(
                            child: Icon(
                          Icons.keyboard_arrow_down,
                          size: 18,
                          color: Theme.of(context).primaryColor,
                        )),
                        hintText: getString(lblGoToCategory),
                        hintStyle: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontSize: 12.adaptSize,
                                fontWeight: FontWeight.w400),
                        items: productTypes.subTypes,
                        onChanged: (value) {
                          context
                              .read<FAQCubit>()
                              .selectCategory(value, value.title ?? '');
                          selectedCategory = value;
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
            body: BlocBuilder<FAQCubit, FAQState>(
              builder: (context, state) {
                if (state is DropDownState) {
                  return itemContainer(state.category);
                }
                return itemContainer(subTypes);
              },
            )));
  }

  Widget itemContainer(SubTypes subTypes) {
    return MFGradientBackground(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: subTypes.types?.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, indexSubType) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        subTypes.types?[indexSubType].header.toString() ?? "",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                        itemCount: subTypes.types?[indexSubType].faq?.length,
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
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 12.v, left: 12),
                                          child: Text(
                                            subTypes.types?[indexSubType]
                                                    .faq![indexFaq].question
                                                    .toString() ??
                                                "",
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
                                              data: subTypes.types?[indexSubType]
                                                    .faq![indexFaq].answer
                                                    .toString() ?? "",
                                                style: {
                                                  "body": Style(
                                                      fontSize: FontSize(AppDimens.labelSmall),
                                                      fontFamily: "Karla",
                                                      fontWeight: FontWeight.w400,
                                                      color: setColorBasedOnTheme(context: context, lightColor: AppColors.textLight, darkColor: AppColors.white)
                                                  )
                                                }
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if ((indexFaq + 1) !=
                                  subTypes.types?[indexSubType].faq?.length)
                                Padding(
                                  padding: EdgeInsets.only(left: 8.v, right: 8.v),
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
