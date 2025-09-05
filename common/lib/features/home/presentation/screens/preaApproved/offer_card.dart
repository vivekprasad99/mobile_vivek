import 'package:common/config/offer_type.dart';
import 'package:common/config/routes/route.dart';
import 'package:common/features/home/data/models/custom_offer_model.dart';
import 'package:common/features/home/data/models/landing_pre_offer_response.dart';
import 'package:common/features/home/data/models/pre_approved_offer_response.dart';
import 'package:common/features/home/presentation/screens/preaApproved/offer_dialog.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OfferCard extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color iconColor, borderColor;
  final Gradient gradient;
  final double textHeight;

  const OfferCard({
    super.key,
    required this.text,
    required this.iconColor,
     required this.borderColor,
    required this.gradient,
    required this.onTap,
    required this.textHeight,

  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
      topRight: Radius.circular(18.0),
      topLeft: Radius.circular(18.0),),
          gradient: gradient,
        ),
        child: Container(
          margin:  EdgeInsets.only(bottom: textHeight),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(text,
                    style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.primaryLight,
                        darkColor: AppColors.primaryLight,
                      ),),),
              ),
              Icon(
                Icons.chevron_right,
                size: 16.h,
                color: setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.primaryLight,
                      darkColor: AppColors.primaryLight,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// ignore_for_file: must_be_immutable
class OfferWidget extends StatelessWidget {
  final List<dynamic> preOfferResponse;
  int offersCount = 0;

  OfferWidget(
      {super.key, required this.preOfferResponse, required this.offersCount,});

  @override
  Widget build(BuildContext context) {
    if (preOfferResponse.isEmpty) {
      return const SizedBox.shrink();
    }
    bool hasOfferDataOnly = false;
    bool hasBothOfferDataAndOffersDetails = false;
    bool hasOffersDetailsOnly = false;
    bool hasOffersListOnly = false;
    List<OfferDetail> genericOffers = [];
    List<OfferDetail> personalizedOffers = [];
    List<OfferDetail> plSuvidhaType = [];
    List<OfferDetail> plLeadSubtype = [];

    for (var e in preOfferResponse) {
      if (e is List) {
        for (OfferDetail offer in e) {
          if (offer.offerType != null) {
            if (offer.offerType!.equalsIgnoreCase(OfferType.generic.value)) {
              List<OfferDetail> genericOffersList = [];
              genericOffersList.add(offer);
              for (int i = 0; i < 2 && i < genericOffersList.length; i++) {
                genericOffers.add(genericOffersList[i]);
              }
            } else if (offer.offerType!
                .equalsIgnoreCase(OfferType.personalized.value)) {
              personalizedOffers.add(offer);
            }
          }
        }
      }
    }

    for (var e in preOfferResponse) {
      if (e is List) {
        for (OfferDetail offer in e) {
          if (offer.offerSubType != null) {
            if (offer.offerSubType!
                .equalsIgnoreCase(OfferType.plSuvidha.value)) {
              plSuvidhaType.add(offer);
            } else if (offer.offerSubType!
                .equalsIgnoreCase(OfferType.plLead.value)) {
              plLeadSubtype.add(offer);
            }
          }
        }
      }
    }

    for (var e in preOfferResponse) {
      if (e is OfferDatum) {
        hasOfferDataOnly = true;
      } else if (e is OffersDetail) {
        hasOffersDetailsOnly = true;
      }
      if (hasOfferDataOnly && hasOffersDetailsOnly) {
        hasBothOfferDataAndOffersDetails = true;
      } else if (!hasOfferDataOnly && !hasOffersDetailsOnly) {
        if (e is List) {
          for (OfferDetail offer in e) {
            if (offer.offerType != null) {
              if (offer.offerType!.equalsIgnoreCase(OfferType.generic.value)) {
                hasOffersListOnly = true;
              }
            }
          }
        }
      }
    }

    int totalOfferCount = offersCount + genericOffers.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasOfferDataOnly ||
            hasOffersDetailsOnly ||
            hasBothOfferDataAndOffersDetails ||
            hasOffersListOnly)
          Row(
            children: [
              Text(
                getString(labelLandingPageActiveOffers),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(
                width: 5.v,
              ),
              totalOfferCount > 2
                  ? GestureDetector(
                      onTap: () {
                        context.pushNamed(Routes.preapprovedOffer.name);
                      },
                      child: Row(
                        children: [
                          Text(
                            '${totalOfferCount - 2} ${getString(labelOfferMore)}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 16.h,
                            color:  Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        SizedBox(height: 5.h),
        if (hasBothOfferDataAndOffersDetails)
          _buildBothWidgets(
              preOfferResponse, context, plSuvidhaType, plLeadSubtype,)
        else if (hasOfferDataOnly)
      SizedBox(
  height: MediaQuery.of(context).size.height * 0.13, 
  child: Stack(
    children: [
      Positioned(
        left: 0,
        right: 0,
        top: MediaQuery.of(context).size.height * 0.01, 
        bottom: MediaQuery.of(context).size.height * 0.01, 
        child: _buildOfferDataWidgets(
          preOfferResponse, context, personalizedOffers, plSuvidhaType,
        ),
      ),
      Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        top: MediaQuery.of(context).size.height * 0.066,
        child: _buildGenricOfferWidgets(
          preOfferResponse, context, genericOffers,
        ).first,
      ),
    ],
  ),
)
        else if (hasOffersDetailsOnly)
          SizedBox(
          height: MediaQuery.of(context).size.height * 0.13,
            child: Stack(
              children: [
                 Positioned(
                  left: 0,
                  right: 0,
                      top: MediaQuery.of(context).size.height * 0.01,
                  bottom: MediaQuery.of(context).size.height * 0.01,
                  child: _buildOffersDetailsWidgets(
                    preOfferResponse,
                    context,
                    personalizedOffers,
                    plLeadSubtype,
                  ),
                ),
               Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  top: MediaQuery.of(context).size.height * 0.07,
                  child: _buildGenricOfferWidgets(
                          preOfferResponse, context, genericOffers)
                      .first,
                ),
              ],
            ),
          )
        else if (hasOffersListOnly)
          ..._buildGenricWidgets(preOfferResponse, context, genericOffers),
      ],
    );
  }


 Widget _buildBothWidgets(List<dynamic> response, BuildContext context,
      List<OfferDetail> plSuvidhaType, List<OfferDetail> plLeadSubtype,) {
    return SizedBox(
     height: MediaQuery.of(context).size.height * 0.13, 
      child: Stack(
        children: response.map((element) {
          return Positioned(
            left: 0,
            right: 0,
            bottom: element is OfferDatum ?MediaQuery.of(context).size.height * 0.05 : 0.adaptSize,
            child: Column(
        children: [
          if (element is OfferDatum)
            OfferCard(
              borderColor: AppColors.offerGradientCardBlue,
              text: textSuvidha(element, plSuvidhaType),
              onTap: () {
                String offerTitle = textSuvidha(element, plSuvidhaType);
                showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (BuildContext context) {
                    return PreOfferDialogBox(
                        offerDetail: plSuvidhaType.first,
                        lcContext: context,
                        customOfferResponse: CustomOfferModel(
                            offerTitle: offerTitle,
                            loanAmount: element.result?.defaultEligibleAmount,
                            emi: element.result?.emiAmount,
                            tenure: element.result?.defaultEligibleTenure,),);
                  },
                );
              },
              gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                         AppColors.offerGradientCardRed,
                   AppColors.offerGradientCardRedWhite,

                  ],),
              iconColor: AppColors.primaryLight, textHeight: 10.adaptSize,
            ),
          if (element is OffersDetail)
            OfferCard(
              textHeight: 0.adaptSize,
                borderColor: AppColors.offerGradientCardBlue,
              text: textPL(element, plLeadSubtype),
              onTap: () {
                String offerTitle = textPL(element, plLeadSubtype);
                showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (BuildContext context) {
                    return PreOfferDialogBox(
                        offerDetail: plLeadSubtype.first,
                        lcContext: context,
                        customOfferResponse: CustomOfferModel(
                            offerTitle: offerTitle,
                            loanAmount: element.currentMaximumAmount,
                            emi: element.maximumemi,
                            tenure: element.currentMaximumTenure,),);
                  },
                );
              },
              gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                AppColors.offerGradientCardBlue,
                  AppColors.offerGradientCardBlueWhite,
                  ],),
              iconColor: AppColors.primaryLight,
            ),
        ],
      )
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOfferDataWidgets(List<dynamic> response,
      BuildContext context, List<OfferDetail> personaldata, plSuvidhaType, ) {
    if (response.isEmpty) return const SizedBox.shrink();
    var firstElement = response.first;
    if (firstElement is OfferDatum) {
      return OfferCard(
              textHeight: 40.adaptSize,
               borderColor: AppColors.offerGradientCardRed,
              text: textSuvidha(firstElement, plSuvidhaType),
              onTap: () {
                showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (BuildContext context) {
                    String offerTitle =
                        textSuvidha(firstElement, plSuvidhaType);
                    return PreOfferDialogBox(
                        offerDetail: plSuvidhaType.first,
                        lcContext: context,
                        customOfferResponse: CustomOfferModel(
                          offerTitle: offerTitle,
                          loanAmount:
                              firstElement.result?.defaultEligibleAmount,
                          emi: firstElement.result?.emiAmount,
                          tenure: firstElement.result?.defaultEligibleTenure,
                        ),);
                  },
                );
              },
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                   AppColors.offerGradientCardRed,
                   AppColors.offerGradientCardRedWhite,
                ],
              ),
              iconColor: AppColors.primaryLight,
            );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildOffersDetailsWidgets(List<dynamic> response,
      BuildContext context, List<OfferDetail> personaldata, plLeadSubtype,) {
      if (response.isEmpty) return const SizedBox.shrink();
    var element = response.first;
    if (element is OffersDetail) {
      return  OfferCard(
          textHeight: 40.adaptSize,
           borderColor: AppColors.offerGradientCardBlue,
          text: textPL(response, plLeadSubtype),
          onTap: () {
            String offerTitle = textPL(element, plLeadSubtype);
            showDialog(
              barrierDismissible: true,
              context: context,
              builder: (BuildContext context) {
                return PreOfferDialogBox(
                    offerDetail: plLeadSubtype.first,
                    lcContext: context,
                    customOfferResponse: CustomOfferModel(
                        offerTitle: offerTitle,
                        loanAmount: element.currentMaximumAmount,
                        emi: element.maximumemi,
                        tenure: element.currentMaximumTenure,),);
              },
            );
          },
          gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.offerGradientCardBlue,
              AppColors.offerGradientCardBlueWhite,
              ],),
          iconColor: AppColors.primaryLight,
        );

    } else {
       return const SizedBox.shrink();
    }
  }

List<Widget> _buildGenricWidgets(List<dynamic> response, BuildContext context, List<OfferDetail> dataList) {
 int itemCount = response.length > 1 ? 1 : 2;
  int genricCount = dataList.length > 1 ? 2 : 1;
  List<OfferDetail> itemsToShow = dataList.take(itemCount).toList();

  if (itemsToShow.length == 2) {
    return [
      Stack(
        alignment: Alignment.center,
        children: [
          _buildOfferCard(itemsToShow[0], context, 0, itemCount, genricCount),
          Positioned(
            top: 46.adaptSize,left: 0.5.adaptSize, right: 0.5.adaptSize,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: _buildOfferCard(itemsToShow[1], context, 1, itemCount, genricCount),
            ),
          ),
        ],
      ),
    ];
  } else {
    return itemsToShow.asMap().entries.map((entry) {
      int index = entry.key;
      OfferDetail element = entry.value;
      return _buildOfferCard(element, context, index, itemCount, genricCount);
    }).toList();
  }
}

Widget _buildOfferCard(OfferDetail element, BuildContext context, int index, int itemCount, int genricCount) {
  LinearGradient gradient;
  Color borderRadiusColor;
  if (itemCount == 1) {
    gradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.offerGradientCardBlue,
        AppColors.offerGradientCardBlueWhite,
      ],
    );
    borderRadiusColor = AppColors.offerGradientCardBlue;
  } else {
    gradient = index % 2 == 0
        ? const LinearGradient(
          stops: [0.1,0.8],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.offerGradientCardRed,
              AppColors.offerGradientCardRedWhite,
            ],
          )
        : const LinearGradient(
          stops: [0.1,0.8],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.offerGradientCardBlue,
              AppColors.offerGradientCardBlueWhite,
            ],
          );
    borderRadiusColor = index % 2 == 0
        ? AppColors.offerGradientCardRed
        : AppColors.offerGradientCardBlue;
  }

  return SizedBox(
    height:genricCount ==1 ? 62.adaptSize : 92.adaptSize,
    child: OfferCard(
      textHeight:genricCount ==1 ? 0: 40.adaptSize,
      borderColor: borderRadiusColor,
      text: element.header?.first.toString() ?? "",
      onTap: () {
        showDialog(
          barrierDismissible: true,
          context: context,
          builder: (BuildContext context) {
            String? loanAmountVal, emiVal, tenureVal;
            loanAmountVal = element.offerDetailTabs?.first.tabDetails?.loanAmount?.toString() ?? '';
            emiVal = element.offerDetailTabs?.first.tabDetails?.emiTenureMax?.toString() ?? '';
            tenureVal = element.offerDetailTabs?.first.tabDetails?.tenure?.toString() ?? '';
            return PreOfferDialogBox(
              offerDetail: element,
              lcContext: context,
              customOfferResponse: CustomOfferModel(
                loanAmount: loanAmountVal,
                emi: emiVal,
                offerTitle: element.header?.first.toString() ?? "",
                tenure: tenureVal,
              ),
            );
          },
        );
      },
      gradient: gradient,
      iconColor: itemCount == 1
          ? Colors.blue
          : (index % 2 == 0 ? AppColors.primaryLight : AppColors.primaryLight),
    ),
  );
}
}

List<Widget> _buildGenricOfferWidgets(List<dynamic> response, BuildContext context, List<OfferDetail> dataList) {
 int itemCount = response.length > 1 ? 1 : 2;
  int genricCount = dataList.length > 1 ? 2 : 1;
  List<OfferDetail> itemsToShow = dataList.take(itemCount).toList();
    return itemsToShow.asMap().entries.map((entry) {
      int index = entry.key;
      OfferDetail element = entry.value;
      return _buildOfferCard(element, context, index, itemCount, genricCount);
    }).toList();

}

Widget _buildOfferCard(OfferDetail element, BuildContext context, int index, int itemCount, int genricCount) {
  LinearGradient gradient;
  Color borderRadiusColor;
  if (itemCount == 1) {
    gradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.offerGradientCardBlue,
        AppColors.offerGradientCardBlueWhite,
      ],
    );
    borderRadiusColor = AppColors.offerGradientCardBlue;
  } else {
    gradient = index % 2 == 0
        ? const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.offerGradientCardRed,
              AppColors.offerGradientCardRedWhite,
            ],
          )
        : const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.offerGradientCardBlue,
              AppColors.offerGradientCardBlueWhite,
            ],
          );
    borderRadiusColor = index % 2 == 0
        ? AppColors.offerGradientCardRed
        : AppColors.offerGradientCardBlue;
  }

  return OfferCard(
    textHeight:itemCount ==1 ? 0: 40.adaptSize,
    borderColor: borderRadiusColor,
    text: element.header?.first.toString() ?? "",
    onTap: () {
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          String? loanAmountVal, emiVal, tenureVal;
          loanAmountVal = element.offerDetailTabs?.first.tabDetails?.loanAmount?.toString() ?? '';
          emiVal = element.offerDetailTabs?.first.tabDetails?.emiTenureMax?.toString() ?? '';
          tenureVal = element.offerDetailTabs?.first.tabDetails?.tenure?.toString() ?? '';
          return PreOfferDialogBox(
            offerDetail: element,
            lcContext: context,
            customOfferResponse: CustomOfferModel(
              loanAmount: loanAmountVal,
              emi: emiVal,
              offerTitle: element.header?.first.toString() ?? "",
              tenure: tenureVal,
            ),
          );
        },
      );
    },
    gradient: gradient,
    iconColor: itemCount == 1
        ? Colors.blue
        : (index % 2 == 0 ? AppColors.primaryLight : AppColors.primaryLight),
  );
}

  String textSuvidha(dynamic textResponse, List<OfferDetail> plSuvidhaType) {
    String getHeaderValue(String placeholder) {
      for (var offer in plSuvidhaType) {
        if (offer.header != null) {
          for (var header in offer.header!) {
            if (header.contains(placeholder)) {
              return header;
            }
          }
        }
      }
      return "";
    }

    String replacePlaceholder(String header, String placeholder, String value) {
      return header.replaceAll(placeholder, value);
    }

    if (textResponse is OfferDatum) {
      if (textResponse.result?.defaultEligibleFlatRatePa != null &&
          (textResponse.result?.defaultEligibleFlatRatePa ?? "").isNotEmpty &&
          getHeaderValue(OfferApiKeyType.offerFlatRate.value)
              .contains(OfferApiKeyType.offerFlatRate.value)) {
        String header = getHeaderValue(OfferApiKeyType.offerFlatRate.value);
        String updatedHeader = replacePlaceholder(
            header,
            OfferApiKeyType.offerFlatRate.value,
            textResponse.result!.defaultEligibleFlatRatePa!,);
        return updatedHeader;
      }
      if (textResponse.result?.defaultEligibleAmount != null &&
          (textResponse.result?.defaultEligibleAmount ?? "").isNotEmpty &&
          getHeaderValue(OfferApiKeyType.offerAmount.value)
              .contains(OfferApiKeyType.offerAmount.value)) {
        String header = getHeaderValue(OfferApiKeyType.offerAmount.value);
        String updatedHeader = replacePlaceholder(
            header,
            OfferApiKeyType.offerAmount.value,
            textResponse.result!.defaultEligibleAmount!,);
        return updatedHeader;
      }
      if (textResponse.result?.defaultEligibleTenure != null &&
          (textResponse.result?.defaultEligibleTenure ?? '').isNotEmpty &&
          getHeaderValue(OfferApiKeyType.offerTenure.value)
              .contains(OfferApiKeyType.offerTenure.value)) {
        String header = getHeaderValue(OfferApiKeyType.offerTenure.value);
        String updatedHeader = replacePlaceholder(
            header,
            OfferApiKeyType.offerTenure.value,
            textResponse.result!.defaultEligibleTenure!,);
        return updatedHeader;
      }
      if (textResponse.result?.offerExpiryDate != null &&
          (textResponse.result?.offerExpiryDate ?? "").isNotEmpty &&
          getHeaderValue(OfferApiKeyType.offerExpiry.value)
              .contains(OfferApiKeyType.offerExpiry.value)) {
        String header = getHeaderValue(OfferApiKeyType.offerExpiry.value);
        String updatedHeader = replacePlaceholder(
            header,
            OfferApiKeyType.offerExpiry.value,
            textResponse.result!.offerExpiryDate!,);
        return updatedHeader;
      }
      return "";
    }

    return "";
  }

  String textPL(dynamic textResponse, List<OfferDetail> plLeadSubtype) {
    String getHeaderValue(String placeholder) {
      for (var offer in plLeadSubtype) {
        if (offer.header != null) {
          for (var header in offer.header!) {
            if (header.contains(placeholder)) {
              return header;
            }
          }
        }
      }
      return "";
    }

    String replacePlaceholder(String header, String placeholder, String value) {
      return header.replaceAll(placeholder, value);
    }

    if (textResponse is List) {
      for (var e in textResponse) {
        if (e is OffersDetail) {
          if (e.defaultInterestRate != null &&
              (e.defaultInterestRate ?? "").isNotEmpty &&
              getHeaderValue(OfferApiKeyType.offerFlatRate.value)
                  .contains(OfferApiKeyType.offerFlatRate.value)) {
            String header = getHeaderValue(OfferApiKeyType.offerFlatRate.value);

            String updatedHeader = replacePlaceholder(header,
                OfferApiKeyType.offerFlatRate.value, e.defaultInterestRate!,);
            return updatedHeader;
          }
          if (e.currentMaximumAmount != null &&
              (e.currentMaximumAmount ?? '').isNotEmpty &&
              getHeaderValue(OfferApiKeyType.offerAmount.value)
                  .contains(OfferApiKeyType.offerAmount.value)) {
            String header = getHeaderValue(OfferApiKeyType.offerAmount.value);
            String updatedHeader = replacePlaceholder(header,
                OfferApiKeyType.offerAmount.value, e.currentMaximumAmount!,);
            return updatedHeader;
          }
          if (e.currentMaximumTenure != null &&
              (e.currentMaximumTenure ?? '').isNotEmpty &&
              getHeaderValue(OfferApiKeyType.offerTenure.value)
                  .contains(OfferApiKeyType.offerTenure.value)) {
            String header = getHeaderValue(OfferApiKeyType.offerTenure.value);
            String updatedHeader = replacePlaceholder(header,
                OfferApiKeyType.offerTenure.value, e.currentMaximumTenure!,);
            return updatedHeader;
          }
          if (e.currentOfferExpiryDate != null &&
              (e.currentOfferExpiryDate ?? "").isNotEmpty &&
              getHeaderValue(OfferApiKeyType.offerExpiry.value)
                  .contains(OfferApiKeyType.offerExpiry.value)) {
            String header = getHeaderValue(OfferApiKeyType.offerExpiry.value);
            String updatedHeader = replacePlaceholder(header,
                OfferApiKeyType.offerExpiry.value, e.currentOfferExpiryDate!,);
            return updatedHeader;
          }
          return "";
        }
      }
    }
    if (textResponse is OffersDetail) {
      if (textResponse.defaultInterestRate != null &&
          (textResponse.defaultInterestRate ?? '').isNotEmpty &&
          getHeaderValue(OfferApiKeyType.offerFlatRate.value)
              .contains(OfferApiKeyType.offerFlatRate.value)) {
        String header = getHeaderValue(OfferApiKeyType.offerFlatRate.value);

        String updatedHeader = replacePlaceholder(
            header,
            OfferApiKeyType.offerFlatRate.value,
            textResponse.defaultInterestRate!,);
        return updatedHeader;
      }
      if (textResponse.currentMaximumAmount != null &&
          (textResponse.currentMaximumAmount ?? '').isNotEmpty &&
          getHeaderValue(OfferApiKeyType.offerAmount.value)
              .contains(OfferApiKeyType.offerAmount.value)) {
        String header = getHeaderValue(OfferApiKeyType.offerAmount.value);
        String updatedHeader = replacePlaceholder(
            header,
            OfferApiKeyType.offerAmount.value,
            textResponse.currentMaximumAmount!,);
        return updatedHeader;
      }
      if (textResponse.currentMaximumTenure != null &&
          (textResponse.currentMaximumTenure ?? "").isNotEmpty &&
          getHeaderValue(OfferApiKeyType.offerTenure.value)
              .contains(OfferApiKeyType.offerTenure.value)) {
        String header = getHeaderValue(OfferApiKeyType.offerTenure.value);
        String updatedHeader = replacePlaceholder(
            header,
            OfferApiKeyType.offerTenure.value,
            textResponse.currentMaximumTenure!,);
        return updatedHeader;
      }
      if (textResponse.currentOfferExpiryDate != null &&
          (textResponse.currentOfferExpiryDate ?? '').isNotEmpty &&
          getHeaderValue(OfferApiKeyType.offerExpiry.value)
              .contains(OfferApiKeyType.offerExpiry.value)) {
        String header = getHeaderValue(OfferApiKeyType.offerExpiry.value);
        String updatedHeader = replacePlaceholder(
            header,
            OfferApiKeyType.offerExpiry.value,
            textResponse.currentOfferExpiryDate!,);
        return updatedHeader;
      }
      return "";
    }

    return "";
  }

