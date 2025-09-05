// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:common/config/offer_type.dart';
import 'package:common/config/routes/route.dart' as common;
import 'package:common/features/home/data/models/custom_offer_model.dart';
import 'package:common/features/home/data/models/landing_pre_offer_request.dart';
import 'package:common/features/home/data/models/landing_pre_offer_response.dart';
import 'package:common/features/home/data/models/pre_approved_offer_response.dart';
import 'package:common/features/home/presentation/cubit/landing_page_cubit.dart';
import 'package:common/features/home/presentation/cubit/landing_page_state.dart';
import 'package:common/features/home/presentation/screens/preaApproved/offer_details_screen.dart';
import 'package:common/features/home/presentation/screens/preaApproved/pre_approved_offer_banner_tab_widget.dart';
import 'package:core/config/network/network_utils.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/action_buttons/sticky_floating_action_button.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:html/parser.dart' as html_parser;

class MyOffersScreen extends StatefulWidget {
  const MyOffersScreen({super.key});

  @override
  State<MyOffersScreen> createState() => _MyOffersScreenState();
}

class _MyOffersScreenState extends State<MyOffersScreen> {
  @override
  void initState() {
    apiCall(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<OfferDetail> genericOffers = [];
    List<OfferDetail> personalizedOffers = [];
    List<OfferDetail> plSuvidhaType = [];
    List<OfferDetail> plLeadSubtype = [];
    List<OffersDetail> plLeadDataApi = [];
    List<OfferDatum> plSuvidhaDataApi = [];
    return BlocConsumer<LandingPageCubit, LandingPageState>(
      listener: (context, state) {
        if (state is MyOfferSuccessState) {
          if (state.code == AppConst.codeFailure) {
            toastForFailureMessage(
                context: context, msg: getString(state.responseCode),);
          }
        }
      },
      buildWhen: (prev, curr) => curr is MyOfferSuccessState,
      builder: (context, state) {
        List<String> categoryOfferType = [];
        if (state is MyOfferSuccessState) {
          for (OfferDetail e in state.cmsOfferResponse) {
            plLeadDataApi = state.plLeadResponse;
            plSuvidhaDataApi = state.suvidhaResponse;
            if (e.offerType != null) {
              if (e.offerType!.equalsIgnoreCase(OfferType.generic.value)) {
                genericOffers.add(e);
              } else if (e.offerType!
                  .equalsIgnoreCase(OfferType.personalized.value)) {
                if (e.offerSubType!
                        .equalsIgnoreCase(OfferType.plSuvidha.value) &&
                    plSuvidhaDataApi.isNotEmpty) {
                  personalizedOffers.add(e);
                }
                if (e.offerSubType!
                        .equalsIgnoreCase(OfferType.plLead.value) &&
                    plLeadDataApi.isNotEmpty) {
                  personalizedOffers.add(e);
                }
              }
            }
          }
    
          personalizedOffers.map((e) {
            if (e.offerSubType!.equalsIgnoreCase(OfferType.plSuvidha.value) &&
                plSuvidhaDataApi.isNotEmpty) {
              plSuvidhaType.add(e);
            } else if (e.offerSubType!
                    .equalsIgnoreCase(OfferType.plLead.value) &&
                plLeadDataApi.isNotEmpty) {
              plLeadSubtype.add(e);
            }
          });
          for (OfferDetail e in state.cmsOfferResponse) {
            if ((e.offerType ?? "").isNotEmpty) {
              if (!categoryOfferType.contains(e.offerType)) {
                if (e.offerType!.equalsIgnoreCase(OfferType.generic.value)) {
                  categoryOfferType.add(e.offerType ?? "");
                }
                if (e.offerType!
                        .equalsIgnoreCase(OfferType.personalized.value) &&
                    (plSuvidhaDataApi.isNotEmpty ||
                        plLeadDataApi.isNotEmpty)) {
                  categoryOfferType.add(e.offerType ?? "");
                }
              }
            }
          }
        }
    
        return DefaultTabController(
          length: categoryOfferType.length,
          child: Scaffold(
            floatingActionButton: const StickyFloatingActionButton(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Padding(
                padding: EdgeInsets.only(right: 160.h),
                child: Text(
                  getString(lblMyOffers),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Theme.of(context).primaryColor),
                ),
              ),
              bottom: categoryOfferType.length > 1
                  ? TabBar(
                      isScrollable: true,
                      indicatorColor: Theme.of(context).highlightColor,
                      labelColor: Theme.of(context).highlightColor,
                      unselectedLabelColor: Theme.of(context).primaryColor,
                      indicatorWeight: 3.0,
                      tabAlignment: TabAlignment.start,
                      tabs: categoryOfferType.map((String value) {
                        return Tab(text: getString(getOfferTabTitle(value)));
                      }).toList(),
                    )
                  : null,
            ),
            body: BlocBuilder<LandingPageCubit, LandingPageState>(
              builder: (context, state) {
                if (state is PreOfferLoadingState &&
                    state.isLoading == true) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: Theme.of(context).highlightColor,
                    strokeWidth: 2,
                  ),);
                }
                return MFGradientBackground(
                  verticalPadding: 0,
                  child: categoryOfferType.isNotEmpty
                      ? TabBarView(
                          children: categoryOfferType.map((String key) {
                            return OfferListTab(
                                personalisedOffer: personalizedOffers,
                                offers: genericOffers,
                                plLeadDataApi: plLeadDataApi,
                                plSuvidhaDataApi: plSuvidhaDataApi,
                                plLeadSubtype: plLeadSubtype,
                                plSuvidhaType: plSuvidhaType,
                                offerType: key,);
                          }).toList(),
                        )
                      : Center(
                          child: Text(getString(msgSearchNoResultFound),
                              style: Theme.of(context).textTheme.titleSmall,),
                        ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

void apiCall(BuildContext context) {
  BlocProvider.of<LandingPageCubit>(context).getDrawerLoanPreOffer(
      landingPreOfferRequest: LandingPreOfferRequest(
          ucic: getUCIC(), mobileNumber: getPhoneNumber(),),);
}

// ignore: must_be_immutable
class OfferListTab extends StatelessWidget {
  final List<OfferDetail> offers;
  final String offerType;
  final List<OfferDetail> personalisedOffer;
  List<OffersDetail>? plLeadDataApi = [];
  List<OfferDatum>? plSuvidhaDataApi = [];
  List<OfferDetail>? plSuvidhaType = [];
  List<OfferDetail>? plLeadSubtype = [];

  OfferListTab(
      {super.key,
      required this.offers,
      required this.offerType,
      this.plLeadDataApi,
      this.plSuvidhaDataApi,
      this.plSuvidhaType,
      this.plLeadSubtype,
      required this.personalisedOffer,});

  @override
  Widget build(BuildContext context) {
    if (offerType.equalsIgnoreCase(OfferType.generic.value)) {
      return ListView.builder(
        itemCount: offers.length,
        itemBuilder: (context, index) {
          var offer = offers[index];
          String? loanAmountVal, emiVal, tenureVal;

          loanAmountVal =
              offer.offerDetailTabs?.first.tabDetails?.loanAmount.toString() ??
                  '';
          emiVal = offer.offerDetailTabs?.first.tabDetails?.emiTenureMax
                  .toString() ??
              '';
          tenureVal =
              offer.offerDetailTabs?.first.tabDetails?.tenure.toString() ?? '';

          return OfferBanner(
            offer: offer,
            offerSpecs: CustomOfferModel(
                offerTitle: offer.header?.first,
                loanAmount: loanAmountVal,
                emi: emiVal,
                tenure: tenureVal,),
          );
        },
      );
    } else {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          childAspectRatio: 0.75,
          mainAxisSpacing: 10,
        ),
        itemCount: personalisedOffer.length,
        itemBuilder: (context, index) {
          var offer = personalisedOffer[index];
          return GenericOfferCard(
            offer: offer,
            personalisedOffer: personalisedOffer,
            plLeadDataApi: plLeadDataApi,
            plSuvidhaDataApi: plSuvidhaDataApi,
            plLeadSubtype: plLeadSubtype,
            plSuvidhaType: plSuvidhaType,
            offerSpecs: CustomOfferModel(
              offerTitle: offer.offerSubType!
                      .equalsIgnoreCase(OfferType.plSuvidha.value)
                  ? textSuvidha(plSuvidhaDataApi!.first, personalisedOffer)
                  : textPl(plLeadDataApi!.first, personalisedOffer),
              loanAmount: offer.offerSubType!
                      .equalsIgnoreCase(OfferType.plLead.value)
                  ? plLeadDataApi!.isNotEmpty
                      ? plLeadDataApi?.first.currentMaximumAmount
                      : ''
                  : plSuvidhaDataApi!.isNotEmpty
                      ? plSuvidhaDataApi?.first.result?.defaultEligibleAmount
                      : '',
              emi: offer.offerSubType!.equalsIgnoreCase(OfferType.plLead.value)
                  ? plLeadDataApi!.isNotEmpty
                      ? plLeadDataApi?.first.maximumemi
                      : ''
                  : plSuvidhaDataApi!.isNotEmpty
                      ? plSuvidhaDataApi?.first.result?.emiAmount
                      : '',
              tenure: offer.offerSubType!
                      .equalsIgnoreCase(OfferType.plLead.value)
                  ? plLeadDataApi!.isNotEmpty
                      ? plLeadDataApi?.first.currentMaximumTenure
                      : ''
                  : plSuvidhaDataApi!.isNotEmpty
                      ? plSuvidhaDataApi?.first.result?.defaultEligibleTenure
                      : '',
            ),
          );
        },
      );
    }
  }
}

String textSuvidha(
    OfferDatum plSuvidhaDataApi, List<OfferDetail> personalisedOffer,) {
  String getHeaderValue(String placeholder) {
    for (var offer in personalisedOffer) {
      if (offer.offerSubType!.equalsIgnoreCase(OfferType.plSuvidha.value)) {
        if (offer.header != null) {
          for (var header in offer.header!) {
            if (header.contains(placeholder)) {
              return header;
            }
          }
        }
      }
    }
    return "";
  }

  String replacePlaceholder(String header, String placeholder, String value) {
    return header.replaceAll(placeholder, value);
  }

  if (plSuvidhaDataApi.result?.defaultEligibleFlatRatePa != null &&
      plSuvidhaDataApi.result!.defaultEligibleFlatRatePa!.isNotEmpty &&
      getHeaderValue(OfferApiKeyType.offerFlatRate.value)
          .contains(OfferApiKeyType.offerFlatRate.value)) {
    String header = getHeaderValue(OfferApiKeyType.offerFlatRate.value);
    String updatedHeader = replacePlaceholder(
        header,
        OfferApiKeyType.offerFlatRate.value,
        plSuvidhaDataApi.result!.defaultEligibleFlatRatePa!,);
    return updatedHeader;
  }
  if (plSuvidhaDataApi.result?.defaultEligibleAmount != null &&
      plSuvidhaDataApi.result!.defaultEligibleAmount!.isNotEmpty &&
      getHeaderValue(OfferApiKeyType.offerAmount.value)
          .contains(OfferApiKeyType.offerAmount.value)) {
    String header = getHeaderValue(OfferApiKeyType.offerAmount.value);
    String updatedHeader = replacePlaceholder(
        header,
        OfferApiKeyType.offerAmount.value,
        plSuvidhaDataApi.result!.defaultEligibleAmount!,);
    return updatedHeader;
  }
  if (plSuvidhaDataApi.result?.defaultEligibleTenure != null &&
      plSuvidhaDataApi.result!.defaultEligibleTenure!.isNotEmpty &&
      getHeaderValue(OfferApiKeyType.offerTenure.value)
          .contains(OfferApiKeyType.offerTenure.value)) {
    String header = getHeaderValue(OfferApiKeyType.offerTenure.value);
    String updatedHeader = replacePlaceholder(
        header,
        OfferApiKeyType.offerTenure.value,
        plSuvidhaDataApi.result!.defaultEligibleTenure!,);
    return updatedHeader;
  }
  if (plSuvidhaDataApi.result?.offerExpiryDate != null &&
      (plSuvidhaDataApi.result?.offerExpiryDate ?? "").isNotEmpty &&
      getHeaderValue(OfferApiKeyType.offerExpiry.value)
          .contains(OfferApiKeyType.offerExpiry.value)) {
    String header = getHeaderValue(OfferApiKeyType.offerExpiry.value);
    String updatedHeader = replacePlaceholder(
        header,
        OfferApiKeyType.offerExpiry.value,
        plSuvidhaDataApi.result!.offerExpiryDate!,);
    return updatedHeader;
  }
  return "";
}

String textPl(OffersDetail e, List<OfferDetail> personalisedOffer) {
  String getHeaderValue(String placeholder) {
    for (var offer in personalisedOffer) {
      if (offer.offerSubType!.equalsIgnoreCase(OfferType.plLead.value)) {
        if (offer.header != null) {
          for (var header in offer.header!) {
            if (header.contains(placeholder)) {
              return header;
            }
          }
        }
      }
    }
    return "";
  }

  String replacePlaceholder(String header, String placeholder, String value) {
    return header.replaceAll(placeholder, value);
  }

  if (e.defaultInterestRate != null &&
      (e.defaultInterestRate ?? "").isNotEmpty &&
      getHeaderValue(OfferApiKeyType.offerFlatRate.value)
          .contains(OfferApiKeyType.offerFlatRate.value)) {
    String header = getHeaderValue(OfferApiKeyType.offerFlatRate.value);

    String updatedHeader = replacePlaceholder(
        header, OfferApiKeyType.offerFlatRate.value, e.defaultInterestRate!,);
    return updatedHeader;
  }
  if (e.currentMaximumAmount != null &&
      (e.currentMaximumAmount ?? '').isNotEmpty &&
      getHeaderValue(OfferApiKeyType.offerAmount.value)
          .contains(OfferApiKeyType.offerAmount.value)) {
    String header = getHeaderValue(OfferApiKeyType.offerAmount.value);
    String updatedHeader = replacePlaceholder(
        header, OfferApiKeyType.offerAmount.value, e.currentMaximumAmount!,);
    return updatedHeader;
  }
  if (e.currentMaximumTenure != null &&
      (e.currentMaximumTenure ?? '').isNotEmpty &&
      getHeaderValue(OfferApiKeyType.offerTenure.value)
          .contains(OfferApiKeyType.offerTenure.value)) {
    String header = getHeaderValue(OfferApiKeyType.offerTenure.value);
    String updatedHeader = replacePlaceholder(
        header, OfferApiKeyType.offerTenure.value, e.currentMaximumTenure!,);
    return updatedHeader;
  }
  if (e.currentOfferExpiryDate != null &&
      (e.currentOfferExpiryDate ?? "").isNotEmpty &&
      getHeaderValue(OfferApiKeyType.offerExpiry.value)
          .contains(OfferApiKeyType.offerExpiry.value)) {
    String header = getHeaderValue(OfferApiKeyType.offerExpiry.value);
    String updatedHeader = replacePlaceholder(
        header, OfferApiKeyType.offerExpiry.value, e.currentOfferExpiryDate!,);
    return updatedHeader;
  }
  return "";
}

class GenericOfferCard extends StatelessWidget {
  final OfferDetail offer;
  final CustomOfferModel offerSpecs;
  final List<OffersDetail>? plLeadDataApi;
  final List<OfferDatum>? plSuvidhaDataApi;
  final List<OfferDetail>? plSuvidhaType;
  final List<OfferDetail>? plLeadSubtype;
  final List<OfferDetail> personalisedOffer;

  const GenericOfferCard({
    super.key,
    required this.offer,
    required this.offerSpecs,
    required this.personalisedOffer,
    this.plLeadDataApi,
    this.plSuvidhaDataApi,
    this.plSuvidhaType,
    this.plLeadSubtype,
  });

  @override
  Widget build(BuildContext context) {
    String desc = parseHtmlString(offer.subHeader.toString());
    return GestureDetector(
      onTap: () {
        context.pushNamed(common.Routes.preapprovedOfferDetails.name,
            extra: OfferDetailPageArguments(
                offerDetail: offer, offerSpecs: offerSpecs,),);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              (offer.image == null || offer.image!.isEmpty)
                  ? SvgPicture.asset(ImageConstant.offersIcon)
                  : Expanded(
                      child: SizedBox(
                        width: 100.h,
                        height: 100.h,
                        child: Image.network(
                          offer.image!,
                          headers: getCMSImageHeader(),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return SvgPicture.asset(
                              ImageConstant.offersIcon,
                              width: 100.h,
                              height: 100.h,
                            );
                          },
                        ),
                      ),
                    ),
              const SizedBox(height: 10.0),
              Text(
                offer.offerSubType!.equalsIgnoreCase(OfferType.plSuvidha.value)
                    ? textSuvidha(plSuvidhaDataApi!.first, personalisedOffer)
                    : textPl(plLeadDataApi!.first, personalisedOffer),
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              const SizedBox(height: 8.0),
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  desc,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              const SizedBox(height: 9.0),
              InkWell(
                child: Row(
                  children: [
                    Text(
                      offer.buttonName ?? getString(lblPreApprovedOfferAvailNow),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).highlightColor,
                          ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).highlightColor,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String parseHtmlString(String htmlString) {
  var document = html_parser.parse(htmlString);
  return document.body?.text ?? '';
}

String getOfferTabTitle(String title) {
  if (title == OfferType.generic.value) {
    return getString(lblGenericOffers);
  } else if (title == OfferType.personalized.value) {
    return getString(lblPreApprovedOffers);
  } else {
    return '';
  }
}
