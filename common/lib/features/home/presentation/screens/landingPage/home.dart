// ignore_for_file: use_build_context_synchronously, library_prefixes

import 'package:common/config/offer_type.dart';
import 'package:common/features/home/data/models/landing_page_banner_response.dart';
import 'package:common/features/home/data/models/landing_pre_offer_request.dart';
import 'package:common/features/home/data/models/loan_amount_request.dart';
import 'package:common/features/home/data/models/pre_approved_offer_response.dart';
import 'package:common/features/home/data/models/welcomeNotify_request.dart';
import 'package:common/features/home/presentation/cubit/landing_page_cubit.dart';
import 'package:common/features/home/presentation/cubit/landing_page_state.dart';
import 'package:common/features/home/presentation/screens/landingPage/explore_product_widget.dart';
import 'package:common/features/home/presentation/screens/landingPage/home_offer_slider.dart';
import 'package:common/features/home/presentation/screens/preaApproved/offer_card.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:common/features/home/presentation/screens/preaApproved/widgets/landing_banner_shimmer.dart';
import 'package:common/features/home/presentation/screens/preaApproved/widgets/landing_offer_shimmer.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/utils/size_utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:product_details/data/models/active_loan_list_request.dart';
import 'package:product_details/data/models/active_loan_list_response.dart';
import 'package:product_details/utils/tab_value_singleton.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:common/config/routes/route.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:product/presentation/utils/image_constant.dart';

import '../../../../../config/constant/notification_event.dart';
import 'landing_page_banner.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool? welcomeNotifyApiCall;
  @override
  void initState() {
    welcomeNotifyApiCall =
        PrefUtils.getBool(PrefUtils.keyWelcomeNotify, false);
    if (welcomeNotifyApiCall == false) {
      PrefUtils.saveBool(PrefUtils.keyWelcomeNotify, true);
    }
    apiCall(context);
    checkCustomer();
    super.initState();
  }

  final CarouselController carouselController = CarouselController();
  int carouselIndex = 0;
  bool showLoading = false;
  List<dynamic> homeOffer = [];
  int offersCount = 0;
  bool showLoadingBanner = false;
  bool showOfferLoading = false;
  List<ActiveLoanData> activeloandList = [];
  List<Banners> homeBanner = [];

  @override
  Widget build(BuildContext context) {
    String langCode = PrefUtils.getString(PrefUtils.keySelectedLanguage, "");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: MFGradientBackground(
        verticalPadding: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            langCode == "en"
                ? GestureDetector(
                    onTap: () {
                      context.pushNamed(Routes.searchScreen.name);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10,),
                      decoration: BoxDecoration(
                          color: setColorBasedOnTheme(
                            context: context,
                            lightColor:
                                AppColors.primaryLight6.withOpacity(0.6),
                            darkColor: AppColors.cardDark,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),),
                      margin: const EdgeInsets.all(6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                ImageConstant.searchIcon,
                                colorFilter: ColorFilter.mode(
                                    Theme.of(context).primaryColor,
                                    BlendMode.srcIn,),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                getString(msgHomeSearchHint),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                        color: setColorBasedOnTheme(
                                          context: context,
                                          lightColor: AppColors.primaryLight3,
                                          darkColor: AppColors.white,
                                        ),
                                        fontSize: 16,),
                              ),
                            ],
                          ),
                          GestureDetector(
                              onTap: () {
                                context.pushNamed(Routes.searchScreen.name,
                                    extra: true,);
                              },
                              child: Icon(Icons.mic,
                                  color: Theme.of(context).primaryColor,),),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            SizedBox(height: 10.h),
            BlocConsumer<LandingPageCubit, LandingPageState>(
              listener: (context, state) {
                if (state is GetLoansSuccess) {
                  if (state.response.code == AppConst.codeFailure) {
                    toastForFailureMessage(
                        context: context,
                        msg: getString(state.response.responseCode ??
                            msgSomethingWentWrong,),);
                  }
                }
              },
              buildWhen: (prev, curr) =>
                  curr is GetLoansSuccess || curr is FailureState,
              builder: (context, state) {
                if (state is LandingLoadingState) {
                  showLoading = state.isLoadingLoans;
                }
                if (state is FailureState) {
                  showLoading = false;
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getString(labelExploreProducts),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        SizedBox(height: 10.h),
                        const ExploreWidget(),
                      ],);
                }
                if (state is GetLoansSuccess) {
                  showLoading = false;
                  if (state.response.code == AppConst.codeSuccess) {
                    if (state.response.loanList != null &&
                        (state.response.loanList ?? []).isNotEmpty) {
                      activeloandList = state.response.loanList!
                          .where((item) =>
                              item.loanStatus!.equalsIgnoreCase("Active"),)
                          .toList();

                      setProductTab(state.response.loanList!);

                      if (activeloandList.isNotEmpty) {
                        BlocProvider.of<LandingPageCubit>(context)
                            .getLoanAmount(
                                landingPageRequest: LoanAmountRequest(
                                    loanNumber: activeloandList[0].loanNumber,
                                    sourceSystem:
                                        activeloandList[0].sourceSystem,),);
                      }
                    }
                  }
                }
                return Skeletonizer(
                  enabled: showLoading,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activeloandList.isEmpty
                            ? getString(lblExploreProduct)
                            : getString(lblActiveProduct),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBox(height: 10.h),
                      activeloandList.isNotEmpty
                          ? LandingPageSlider(data: activeloandList)
                          : const ExploreWidget(),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 20.h),
            BlocBuilder<LandingPageCubit, LandingPageState>(
              buildWhen: (prev, curr) => curr is GetBannerSuccess,
              builder: (context, state) {
                if (state is LandingBannerLoadingState) {
                  showLoadingBanner = state.isLoadingBanner;
                }
                if (state is BannerFailureState) {
                  showLoadingBanner = false;
                  return Center(child: Text(getString(msgSomethingWentWrong)));
                }
                if (state is GetBannerSuccess) {
                  showLoadingBanner = false;
                  homeBanner = state.response.data?.banners ?? [];
                }
                return Skeletonizer(
                  enabled: showLoadingBanner,
                  child: !showLoadingBanner
                      ? homeBanner.isNotEmpty
                          ? HomeOffersSlider(homeBanner: homeBanner)
                          : const SizedBox.shrink()
                      : const LandingBannerShimmer(),
                );
              },
            ),
            SizedBox(height: 10.h),
            const Spacer(),
            BlocConsumer<LandingPageCubit, LandingPageState>(
              listener: (context, state) {
                if (state is GetOfferBind) {
                  if (state.code == AppConst.codeFailure) {
                    if (state.response.isNotEmpty) {
                      for (var responseList in state.response) {
                        bool containsGenericOffers = responseList.any(
                            (OfferDetail? item) =>
                                item != null &&
                                item.offerType != null &&
                                item.offerType!
                                    .equalsIgnoreCase(OfferType.generic.value));
                        if (!containsGenericOffers) {
                          toastForFailureMessage(
                              context: context,
                              msg: getString(state.responseCode));
                        }
                      }
                    }
                  }
                }
              },
              buildWhen: (prev, curr) => curr is GetOfferBind,
              builder: (context, state) {
                if (state is LandingPreOfferLoadingState) {
                  showOfferLoading = state.isLoading;
                }
                if (state is PreOfferFailureState) {
                  return Center(child: Text(getString(msgSomethingWentWrong)));
                }
                if (state is GetOfferBind) {
                  showOfferLoading = false;
                  homeOffer = state.response;
                  offersCount = state.offerCount;
                }

                return Skeletonizer(
                    enabled: showOfferLoading,
                    child: !showOfferLoading
                        ? homeOffer.isNotEmpty
                            ? OfferWidget(
                                preOfferResponse: homeOffer,
                                offersCount: offersCount,)
                            : const SizedBox.shrink()
                        : const OfferCardShimmer(),);
              },
            ),
          ],
        ),
      ),
    );
  }

  void apiCall(BuildContext context) async {
    await Future.wait([
      welcomeNotifyApiCall == false
          ? BlocProvider.of<LandingPageCubit>(context).welcomeNotify(
        welcomeNotifyRequest: WelcomeNotifyRequest(
                  contactKey: getSuperAppId(),
                  ucic: getUCIC(),
                  eventDefinitionKey: welcomeNotificationEvent,
                  superAppId: getSuperAppId(),
                  sfmcDeviceId: "",
                  smsStatus: "",
                  emailStatus: "",
                  pushNotificationStatus: "",
                  whatsappStatus: "",
                  notificationCategory: "login",
                  loginType: "app_register",
                  cta: "regstatus",
                  smsRedirectUrl: "",
                  emailRedirectUrl: "",
                  pushRedirectUrl: "",
                  mobileNumber: "91${getPhoneNumber()}",
                  emailId: "",
                  name: "",
                  lan: "CDPL382328DHSFS",
                  registrationStatusFlag: false,
                  registrationTime: "",
                  registrationDate: "",),)
          : Future(() => null),
     BlocProvider.of<LandingPageCubit>(context).getLandingBannerList(),
      BlocProvider.of<LandingPageCubit>(context).getLoanPreOffer(
          landingPreOfferRequest: LandingPreOfferRequest(
              ucic: getUCIC(), mobileNumber: getPhoneNumber(),),),
      isCustomer()
          ? BlocProvider.of<LandingPageCubit>(context).getLoanList(
              landingPageRequest: ActiveLoanListRequest(ucic: getUCIC()),)
          : Future(() => null),
    ]);
  }

  void setProductTab(List<ActiveLoanData> loanList) {
    if (loanList.isNotEmpty) {
      List<ActiveLoanData>? activeLoanList = loanList
          .where((loan) => loan.loanStatus?.toLowerCase() == 'active')
          .toList();

      List<ActiveLoanData>? closedLoanList = loanList
          .where((loan) =>
              loan.loanStatus?.toLowerCase() == 'closed' ||
              loan.loanStatus?.toLowerCase() == 'Inactive' ||
              loan.loanStatus?.toLowerCase() == 'Cancelled')
          .toList();

      if ((activeLoanList).isNotEmpty) {
        TabValueSingleton.instance.saveValue(2);
      } else if ((closedLoanList).isNotEmpty) {
        TabValueSingleton.instance.saveValue(3);
      }
    }
  }

  void checkCustomer() {
    if(isCustomer()){
      TabValueSingleton.instance.saveValue(2);
    }else{
      TabValueSingleton.instance.saveValue(0);
    }
  }
}
