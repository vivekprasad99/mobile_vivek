import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:faq/config/routes/route.dart';
import 'package:faq/features/data/models/faq_response.dart';
import 'package:faq/features/presentation/widgets/common_widgets/youtube_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// ignore_for_file: must_be_immutable
class HowToTab extends StatefulWidget {
  List<VideoTypes>? videoType;

  HowToTab(this.videoType, {super.key});

  @override
  State<HowToTab> createState() => _HowToTabState();
}

class _HowToTabState extends State<HowToTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: MFGradientBackground(
          horizontalPadding: 12,
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  for (var element in widget.videoType!) categoryRow(element),
                ],
              ),
            ),
          ),
        ));
  }

  Widget categoryRow(VideoTypes videoElement) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              videoElement.header!,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600),
            ),
            GestureDetector(
                onTap: () {
                  context.pushNamed(Routes.howToCategory.name,
                      extra: videoElement);
                },
                child: Text(getString(lblViewAll),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: setColorBasedOnTheme(
                          context: context,
                          lightColor: AppColors.primaryLight3,
                          darkColor: AppColors.secondaryLight5,
                        ))))
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
            height: 150,
            child: ListView.builder(
              itemCount: videoElement.videos?.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (itemContext, index) {
                return GestureDetector(
                    onTap: () {
                      context.pushNamed(Routes.youtubePlayerScreen.name,
                          extra: videoElement.videos?[index].videoUrl);
                    },
                    child: YoutubeCard(videoElement.videos?[index]));
              },
            )),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
