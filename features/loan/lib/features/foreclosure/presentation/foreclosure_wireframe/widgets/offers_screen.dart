import 'package:common/config/routes/app_route.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/custom_outline_button.dart';
import 'package:lead_generation/config/routes/route.dart' as lead_gen;
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_cms_image.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:loan/features/foreclosure/data/models/get_loan_details_response.dart';
import 'package:loan/features/foreclosure/presentation/foreclosure_wireframe/widgets/offer_slider_widget.dart';
import '../../../data/models/get_offers_response.dart';

class OffersScreen extends StatelessWidget {
  final List<Offers>? offers;
  final Function(BuildContext)? onRejected;
  final LoanDetails? loanDetails;
  final int? selectedReasonId;
  final BuildContext? offerContext;
  const OffersScreen(
      {super.key,
      required this.loanDetails,
      required this.offers,
      required this.onRejected,
      required this.offerContext,
      this.selectedReasonId});

  @override
  Widget build(BuildContext context) {
    String screenTitle = selectedReasonId == 2
        ? getString(msgFixedDepositOffer)
        : getString(msgPreApprovedOffer);

    return Scaffold(
      appBar: customAppbar(
          context: context,
          title: "",
          onPressed: () {
            Navigator.of(context).pop();
          }),
      body: MFGradientBackground(
        child: Column(
          children: [
            Text(
              screenTitle,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            SizedBox(
              height: 32.v,
            ),
            offers!.length == 1
                ? singleOfferCard(context, offers!.first)
                : OfferSliderDemo(
                dialogContext:offerContext,
                    onPressed: () {
                      Navigator.of(context).pop();
                      AppRoute.router.pushNamed(lead_gen.Routes.leadGeneration.name,
                          pathParameters: {'leadType': "fixed_deposit"});
                    },
                    offersCard: [
                      ListView.builder(
                          itemCount: (offers ?? []).length,
                          itemBuilder: (context, index) {
                            return multipleOfferCard(context, offers![index]);
                          })
                    ],
                  )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomOutlinedButton(
            height: 48.v,
            text: getString(noProceedForeclosure),
            margin: EdgeInsets.only(right: 15.h, left: 15.h),
            buttonStyle: OutlinedButton.styleFrom(
              side: BorderSide(
                color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.secondaryLight,
                  darkColor: AppColors.secondaryLight5,
                ),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.h),
              ),
            ),
            buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.secondaryLight,
                  darkColor: AppColors.secondaryLight5,
                )),
            onPressed: () {
              onRejected!(context);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget singleOfferCard(BuildContext context, Offers offers) {
    return MFCMSImage(url: offers.image ?? "");
  }

  Widget multipleOfferCard(BuildContext context, Offers offer) {
    return MFCMSImage(url: offer.image ?? "");
  }
}
