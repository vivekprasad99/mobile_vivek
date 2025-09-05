import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/config.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/terms_conditions_request.dart';
import '../../cubit/terms_conditions_cubit.dart';
import '../../cubit/terms_conditions_state.dart';

class TermsConditionScreen extends StatelessWidget {
  final bool? isFromSideMenu;
  const TermsConditionScreen({super.key,this.isFromSideMenu});

  @override
  Widget build(BuildContext context) {
    TermsConditionsRequest request =
        TermsConditionsRequest(category: "terms-conditions", language: "en");
    BlocProvider.of<TermsConditionsCubit>(context).getTermsConditions(request);
    return Scaffold(
        bottomNavigationBar: isFromSideMenu ?? false
            ? null
            : Padding(padding: const EdgeInsets.all(16), child: MfCustomButton(
               outlineBorderButton: false,
                onPressed: () {
                  context.pop(true);
                },
                text: getString(lblAccept),),),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          toolbarHeight: 50.h,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          leadingWidth: 38,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: setColorBasedOnTheme(
                context: context,
                lightColor: AppColors.secondaryLight,
                darkColor: AppColors.backgroundLight5,),
            onPressed: () {
              context.pop(false);
            },
          ),
          elevation: 0.0,
          title: Text(
            getString(termsCondTitle),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        body: BlocBuilder<TermsConditionsCubit, TermsConditionsState>(
            builder: (context, state) {
          if (state is LoadingState && state.isLoading) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: Center(
                  child: CircularProgressIndicator(
                color: Theme.of(context).indicatorColor,
                strokeWidth: 2,
              ),),
            );
          }
          if (state is TermsConditionsSuccessState) {
            var htmlData = state.response.data ?? "";
            return MFGradientBackground(
                  verticalPadding: 0,
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical, //.horizontal
                  child: Html(
                    key: UniqueKey(),
                    data: htmlData,
                    onLinkTap: (url, attributes, element) async{
                     var urlN= Uri.parse(url!);
                      if (await canLaunchUrl(urlN)) {
                          await launchUrl(
                            urlN,
                          );
                        } else {
                          throw 'Could not launch $url';
                        }
                  },
                    style: {
                      "h2": Style(
                        fontSize: FontSize(24),
                        fontWeight: FontWeight.bold,
                      ),
                      "h3": Style(
                        fontSize: FontSize(20),
                        fontWeight: FontWeight.bold,
                      ),
                      "p": Style(
                        fontSize: FontSize(16),
                      ),
                      "ul": Style(
                        fontSize: FontSize(16),

                      ),
                      "li": Style(
                        padding: HtmlPaddings.symmetric(vertical: 5),
                      ),
                      "a": Style(
                        color: Colors.red,
                        textDecoration: TextDecoration.none,
                      ),
                      "img": Style(
                        margin: Margins.symmetric(vertical: 10),
                      ),
                    },
                ),
              ),
            );
          }
          return const Text(msgSomethingWentWrong);
        },),);
  }
}
