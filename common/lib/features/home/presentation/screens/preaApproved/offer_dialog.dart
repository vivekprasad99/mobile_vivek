import 'package:common/config/offer_type.dart';
import 'package:common/config/routes/app_route.dart';
import 'package:common/config/routes/route.dart';
import 'package:common/features/home/data/models/custom_offer_model.dart';
import 'package:common/features/home/data/models/pre_approved_offer_response.dart';
import 'package:common/features/home/presentation/screens/preaApproved/offer_details_screen.dart';
import 'package:core/config/network/network_utils.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:flutter_svg/svg.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:lead_generation/config/routes/route.dart' as lead_gen;

class PreOfferDialogBox extends StatelessWidget {
  const PreOfferDialogBox(
      {super.key,
      required this.offerDetail,
      required this.lcContext,
      required this.customOfferResponse,});
  final BuildContext lcContext;
  final OfferDetail offerDetail;
  final CustomOfferModel customOfferResponse;

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.v)),
      elevation: 0.0,
      child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: dialogContent(context, brightness),),
    );
  }

  Widget dialogContent(BuildContext context, Brightness brightness) {
    String offerTitle = '';
    String desc = parseHtmlString(offerDetail.subHeader.toString());
    if (customOfferResponse.offerTitle == null) {
      offerTitle = parseHtmlString(offerDetail.header.toString());
    } else {
      offerTitle = parseHtmlString(customOfferResponse.offerTitle.toString());
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            (offerDetail.image == null || offerDetail.image!.isEmpty)
                ? SizedBox(child: SvgPicture.asset(ImageConstant.offersIcon))
                : SizedBox(
                    height: 250.adaptSize,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0)),
                      child: Image.network(
                      offerDetail.image!,
                        headers: getCMSImageHeader(),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return SvgPicture.asset(
                            ImageConstant.offersIcon,
                            width: double.infinity,
                          );
                        },
                      ),
                    ),
                  ),
            Positioned(
              right: 12.adaptSize,
              top: 6.adaptSize,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(Icons.close, color: Colors.white),),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                offerTitle,
                style: Theme.of(context).textTheme.titleLarge,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8.h),
              Text(
                desc,
                style: Theme.of(context).textTheme.labelMedium,
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 16.h),
              InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    AppRoute.router.pushNamed(
                        Routes.preapprovedOfferDetails.name,
                        extra: OfferDetailPageArguments(
                            offerDetail: offerDetail,
                            offerSpecs: CustomOfferModel(
                                offerTitle:
                                    customOfferResponse.offerTitle ??
                                        offerTitle,
                                loanAmount: customOfferResponse.loanAmount,
                                emi: customOfferResponse.emi,
                                tenure: customOfferResponse.tenure,),),);
                  },
                  child: Text(
                    getString(lblKnowMore),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).highlightColor,
                        decoration: TextDecoration.underline,),
                  ),),
              SizedBox(height: 16.h),
              _buildDoneButton(context,offerDetail),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDoneButton(BuildContext context,OfferDetail offerDetail) {
    return MfCustomButton(
        text: offerDetail.buttonName ?? getString(lblLandingPageApplyNow),
        outlineBorderButton: false,
        isDisabled: false,
        onPressed: () async {
          Navigator.of(context).pop();
           if (offerDetail.offerSubType != null)
           {
              if (offerDetail.offerSubType!.equalsIgnoreCase(OfferType.plLead.value)) {
            AppRoute.router.pushNamed(lead_gen.Routes.leadGeneration.name,
                pathParameters: {'leadType': "PL"},);
          } else {
            AppRoute.router.pushNamed(lead_gen.Routes.leadGeneration.name,
                pathParameters: {'leadType': 'common'},);
          }
           }
           else {
            AppRoute.router.pushNamed(lead_gen.Routes.leadGeneration.name,
                pathParameters: {'leadType': 'common'},);
          }
        },);
  }

  String parseHtmlString(String htmlString) {
    var document = html_parser.parse(htmlString);
    return document.body?.text ?? '';
  }
}
