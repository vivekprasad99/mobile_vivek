import 'package:common/features/home/data/models/custom_offer_model.dart';
import 'package:common/features/home/data/models/pre_approved_offer_response.dart';
import 'package:common/features/home/presentation/cubit/landing_page_cubit.dart';
import 'package:common/features/home/presentation/screens/preaApproved/offer_detail_widget.dart';
import 'package:common/features/home/presentation/screens/preaApproved/widgets/offer_template.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/Strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lead_generation/config/routes/route.dart' as lead_gen;

class OfferDetailPageArguments {
  final OfferDetail? offerDetail;
  final CustomOfferModel? offerSpecs;

  OfferDetailPageArguments({this.offerDetail, this.offerSpecs});
}

class OfferDetailPage extends StatefulWidget {
  const OfferDetailPage({
    super.key,
    required this.data,
  });

  final OfferDetailPageArguments? data;

  @override
  OfferDetailPageState createState() => OfferDetailPageState();
}

class OfferDetailPageState extends State<OfferDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  List<OfferDetailTab> offerDetailTabs = [];
  bool _isApiCalled = false;
  late BuildContext blocContext;
  bool? enableTNCCheckbox = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<LandingPageCubit>(context).getLandingOfferList();
    tabController = TabController(
      length: widget.data?.offerDetail?.offerDetailTabs?.length ?? 0,
        vsync: this,);
    if (!_isApiCalled) {
      BlocProvider.of<LandingPageCubit>(context).getLandingOfferList();
      _isApiCalled = true;
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    offerDetailTabs = widget.data?.offerDetail?.offerDetailTabs ?? [];
    return Scaffold(
      appBar: customAppbar(
        context: context,
        title: getString(lblOfferDetail),
        onPressed: () {
          Navigator.of(context).pop();
            },),
      body: MFGradientBackground(
        child: Column(
          children: [
            OfferTemplate(
              offerTitle: widget.data?.offerSpecs?.offerTitle ?? "",
                  offersList: widget.data?.offerDetail as OfferDetail,),
            TabBar(
              padding: EdgeInsets.zero,
              controller: tabController,
              labelColor: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.secondaryLight,
                  darkColor: AppColors.backgroundLight),
              unselectedLabelColor: Theme.of(context).primaryColor,
              indicatorColor: Theme.of(context).highlightColor,
              tabs: offerDetailTabs
                    .map((offerDetailTabs) =>
                        Tab(text: offerDetailTabs.tabTitle),)
                  .toList(),
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: offerDetailTabs.map((tab) {
                  return SingleChildScrollView(
                    child: OfferDetailsWidget(
                      offerDetailTabs: offerDetailTabs,
                      position: offerDetailTabs.indexOf(tab),
                      customOfferResponse: widget.data?.offerSpecs,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            MfCustomButton(
              onPressed: () {
                if (widget.data?.offerDetail?.offerSubType
                        ?.equalsIgnoreCase("pl-lead") ==
                    true) {
                      context.pushNamed(lead_gen.Routes.leadGeneration.name,
                          pathParameters: {'leadType': "PL"},);
                } else {
                      context.pushNamed(lead_gen.Routes.leadGeneration.name,
                          pathParameters: {'leadType': 'common'},);
                }
              },
              text: widget.data?.offerDetail?.buttonName ?? getString(lblPreApprovedOfferAvailNow),
              width: MediaQuery.of(context).size.width * 0.9,
                  outlineBorderButton: false,),
          ],
        ),
        ),);
  }
}
