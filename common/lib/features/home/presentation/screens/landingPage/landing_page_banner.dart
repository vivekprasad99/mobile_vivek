import 'package:carousel_slider/carousel_slider.dart';
import 'package:common/config/routes/route.dart';
import 'package:common/features/home/data/models/loan_amount_request.dart';
import 'package:common/features/home/presentation/cubit/landing_page_cubit.dart';
import 'package:common/features/home/presentation/cubit/landing_page_state.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:product_details/config/routes/route.dart' as product;
import 'package:product_details/data/models/active_loan_list_response.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LandingPageSlider extends StatefulWidget {
  const LandingPageSlider({super.key, required this.data});

  final List<ActiveLoanData> data;

  @override
  State<LandingPageSlider> createState() => _LandingPageBannerState();
}

class _LandingPageBannerState extends State<LandingPageSlider> {
  final CarouselController carouselController = CarouselController();
  final ValueNotifier<int> carouselIndexNotifier = ValueNotifier<int>(0);
  int carouselIndex = 0;
  final bool hasLoan = true;
  final bool hasInvestment = true;
  String? loanAmountValue;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isNotEmpty) {
      List<Tab> tabs = [];
      List<Widget> tabViews = [];

      if (!hasLoan) {
        tabs.add(const Tab(text: 'Loans'));
        tabViews.add(_buildTab(context, dataType: 'loan'));
      }
      if (!hasInvestment) {
        tabs.add(const Tab(text: 'Investments'));
        tabViews.add(_buildTab(context, dataType: 'investment'));
      }

      return _buildLoanTab(context, widget.data);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildTab(BuildContext context, {required String dataType}) {
    List<Map<String, String>> items = dataType == 'loan'
        ? [
            {
              "loanType": "Car",
              "loanAmount": "200000",
              "assetNumber": "MH 03  XY 0334",
              "amountOverdue": "12000",
              "emiDate": "On 6 Feb 2024",
              "instalmentAmount": "12000",
              "emiOverdue": "",
              "chargesOverdue": "",
            },
            {
              "loanType": "Car",
              "loanAmount": "100000",
              "assetNumber": "#32432",
              "amountOverdue": "11000",
              "emiDate": "On 7 Feb 2024",
              "instalmentAmount": "32000",
              "emiOverdue": "",
              "chargesOverdue": "",
            }
          ]
        : [
            {
              "loanType": "Invest",
              "loanAmount": "65766",
              "assetNumber": "MH 03  XY 0334",
              "amountOverdue": "12000",
              "emiDate": "On 6 Feb 2024",
              "instalmentAmount": "12000",
              "emiOverdue": "",
              "chargesOverdue": "",
            },
            {
              "loanType": "Invest",
              "loanAmount": "8777",
              "assetNumber": "#32432",
              "amountOverdue": "11000",
              "emiDate": "On 7 Feb 2024",
              "instalmentAmount": "32000",
              "emiOverdue": "",
              "chargesOverdue": "",
            }
          ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            CarouselSlider(
              items: items.map((item) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 0.0, vertical: 10.0,),
                  decoration: BoxDecoration(
                    color: setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.white,
                      darkColor: AppColors.cardDark,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10.0,),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item['loanType'] ?? '',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  Text(
                                    '₹${item['loanAmount'] ?? ""}',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                              Text(
                                item['assetNumber'] ?? "",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              const SizedBox(height: 10.0),
                              Text(
                                getString(labelAmountDue),
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '₹${item['amountOverdue'] ?? ""}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge,
                                        ),
                                        Text(
                                          item['emiDate'] ?? "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                  MfCustomButton(
                                    onPressed: () {
                                    },
                                    text: getString(lblLandingPagePayButton),
                                    width: MediaQuery.of(context).size.height *
                                        0.14,
                                    outlineBorderButton: false,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                scrollPhysics: const BouncingScrollPhysics(),
                aspectRatio: 2.0,
                enableInfiniteScroll: false,
                viewportFraction: 1,
                enlargeCenterPage: true,
                initialPage: 0,
                autoPlay: false,
                onPageChanged: (index, reason) {},
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: _buildIndicators(items),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoanTab(BuildContext context, List<ActiveLoanData> data) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            CarouselSlider(
              items: [
                ...data.take(2).map((item) {
                  String dueDate = formattedDate(
                      item.nextDuedate != null && item.nextDuedate != ''
                          ? item.nextDuedate.toString()
                          : "0000-00-00",);

                  String formattedAmount = formatCurrency(getTotalPayableAmount(item)).toString();
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 15.0,),
                    decoration: BoxDecoration(
                      color: setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.white,
                        darkColor: AppColors.cardDark,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.productCategory ?? '',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            BlocConsumer<LandingPageCubit, LandingPageState>(
                              listener: (context, state) {
                                if (state is GetLoansSuccess) {
                                  if (state.response.code ==
                                      AppConst.codeFailure) {
                                    toastForFailureMessage(
                                        context: context,
                                        msg: getString(
                                            state.response.responseCode ??
                                                msgSomethingWentWrong,),);
                                  }
                                }
                              },
                              buildWhen: (previous, current) =>
                                  current is GetLoanAmountSuccess ||
                                  current is LoanAmountLoadingState ||
                                  current is FailureState,
                              builder: (BuildContext context,
                                  LandingPageState state,) {
                                if (state is LoanAmountLoadingState) {
                                  return Skeletonizer(
                                      child: Text(getString(lblLoading)),);
                                }
                                if (state is GetLoanAmountSuccess) {
                                  if (state.response.code ==
                                      AppConst.codeSuccess) {
                                    loanAmountValue =
                                        state.response.data?.loanAmount ?? "";
                                    String amountValue = "";
                                    if ((loanAmountValue ?? "").isNotEmpty) {
                                      amountValue = formatCurrency(double.parse(
                                              loanAmountValue.toString(),),)
                                          .toString();
                                    }
                                    return Text(
                                      amountValue,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    );
                                  }
                                }
                                if (state is FailureState) {
                                  return Text(
                                    loanAmountValue ?? "",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  );
                                }
                                return const Text("----");
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          formatVehicleNumber(item.vehicleRegistration ?? ''),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(height: 20.0),
                        Text(
                          getString(labelTotalPayAmount),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 5.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formattedAmount,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge,
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    'On $dueDate',
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                ],
                              ),
                            ),
                            MfCustomButton(
                              onPressed: () {
                                item.totalPayableAmount =
                                    getTotalPayableAmount(item);
                                context.pushNamed(
                                    product
                                        .Routes.productsPaymentsDetailPage.name,
                                    extra: item,);
                              },
                              text: getString(lblLandingPagePayButton),
                              width: MediaQuery.of(context).size.height * 0.14,
                              outlineBorderButton: false,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
                if (data.length >= 3) _buildContainer(context),
              ],
              options: CarouselOptions(
                scrollPhysics: const BouncingScrollPhysics(),
                enableInfiniteScroll: false,
                viewportFraction: 1,
                aspectRatio: 16 / 9,
                enlargeCenterPage: true,
                initialPage: 0,
                autoPlay: false,
                onPageChanged: (index, reason) {
                  carouselIndexNotifier.value = index;
                  BlocProvider.of<LandingPageCubit>(context).getLoanAmount(
                      landingPageRequest: LoanAmountRequest(
                          loanNumber: data[index].loanNumber,
                          sourceSystem: data[index].sourceSystem,),);
                },
              ),
            ),
            data.length > 1
                ? Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: ValueListenableBuilder<int>(
                      builder: (context, index, _) {
                        return _buildLoanIndicators(index);
                      },
                      valueListenable: carouselIndexNotifier,
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ],
    );
  }

  Widget _buildIndicators(List<Map<String, String>> items) {
    int numberOfContainersToShow = items.length > 3 ? 3 : widget.data.length;

    List<Widget> indicators = [];
    for (int i = 0; i < numberOfContainersToShow; i++) {
      indicators.add(GestureDetector(
        onTap: () => carouselController.animateToPage(i),
        child: Container(
          width: 8,
          height: 4.0,
          margin: const EdgeInsets.symmetric(horizontal: 3.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: carouselIndex == i
                ? Theme.of(context).primaryColor
                : AppColors.primaryLight4,
          ),
        ),
      ),);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: indicators,
    );
  }

  Widget _buildLoanIndicators(int index) {
    int numberOfContainersToShow =
        widget.data.length > 3 ? 3 : widget.data.length;

    List<Widget> indicators = [];
    for (int i = 0; i < numberOfContainersToShow; i++) {
      indicators.add(GestureDetector(
        onTap: () => carouselController.animateToPage(i),
        child: Container(
          width: 8,
          height: 4.0,
          margin: const EdgeInsets.symmetric(horizontal: 3.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: index == i
                ? Theme.of(context).primaryColor
                : AppColors.primaryLight4,
          ),
        ),
      ),);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: indicators,
    );
  }
}

Widget _buildContainer(BuildContext context) {
  return Container(
    color: setColorBasedOnTheme(
      context: context,
      lightColor: AppColors.white,
      darkColor: AppColors.cardDark,
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRowOfContainers(context,
              height: 20.adaptSize, widths: [125, 125],),
          SizedBox(height: 16.adaptSize),
          _buildSingleContainer(context,
              height: 20.adaptSize, width: 83.adaptSize,),
          SizedBox(height: 16.adaptSize),
          _buildRowWithButton(context),
        ],
      ),
    ),
  );
}

Widget _buildRowOfContainers(BuildContext context,
    {required double height, required List<double> widths,}) {
  return Row(
    children: [
      Expanded(
        child: Container(
          height: height,
          color: setColorBasedOnTheme(
            context: context,
            lightColor: AppColors.primaryLight6,
            darkColor: AppColors.emptyContainerDark,
          ),
          width: widths[0],
        ),
      ),
      SizedBox(width: 16.adaptSize),
      Expanded(
        child: Container(
          height: height,
          color: setColorBasedOnTheme(
            context: context,
            lightColor: AppColors.primaryLight6,
            darkColor: AppColors.emptyContainerDark,
          ),
          width: widths[1],
        ),
      ),
    ],
  );
}

Widget _buildSingleContainer(BuildContext context,
    {required double height, required double width,}) {
  return Container(
    height: height,
    width: width,
    color: setColorBasedOnTheme(
      context: context,
      lightColor: AppColors.primaryLight6,
      darkColor: AppColors.emptyContainerDark,
    ),
  );
}

Widget _buildRowWithButton(BuildContext context) {
  return Row(
    children: [
      Expanded(
        child: Container(
          height: 67.adaptSize,
          width: 146.adaptSize,
          color: setColorBasedOnTheme(
            context: context,
            lightColor: AppColors.primaryLight6,
            darkColor: AppColors.emptyContainerDark,
          ),
        ),
      ),
      SizedBox(width: 56.adaptSize),
      MfCustomButton(
        onPressed: () {
          context.pushNamed(Routes.home.name, extra: 1);
        },
        text: getString(lblLandingPageViewAll),
        width: MediaQuery.of(context).size.height * 0.14,
        outlineBorderButton: false,
      ),
    ],
  );
}

String formattedDate(String dateString) {
  DateTime date = DateTime.parse(dateString);
  String formatted = DateFormat('d MMM y').format(date);
  return formatted;
}

String formatCurrency(double amount) {
  final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
  return formatter.format(amount);
}

double getTotalPayableAmount(ActiveLoanData data) {
  double totalPayableAmount = 0.0;
  if ((data.totalAmountOverdue ?? 0.0) > 0) {
    totalPayableAmount = (data.totalAmountOverdue ?? 0.0);
  } else {
    totalPayableAmount = (data.installmentAmount ?? 0.0);
  }
  return totalPayableAmount;
}

String formatVehicleNumber(String number) {
  if (number.length != 10) return number;
  return '${number.substring(0, 2)} ${number.substring(2, 4)} ${number.substring(4, 6)} ${number.substring(6)}';
}
