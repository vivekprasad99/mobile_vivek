import 'package:core/config/widgets/action_buttons/sticky_floating_action_button.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:faq/features/data/models/faq_response.dart';
import 'package:faq/features/presentation/widgets/common_widgets/email_footer.dart';
import 'package:faq/features/presentation/widgets/common_widgets/youtube_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/routes/route.dart';

class HowToCategoryScreen extends StatefulWidget {
  const HowToCategoryScreen({this.videoTypes, super.key});

  final VideoTypes? videoTypes;

  @override
  State<HowToCategoryScreen> createState() => _HowToCategoryScreenState();
}

class _HowToCategoryScreenState extends State<HowToCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButton: const StickyFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomSheet: emailFooter(context),
      appBar: AppBar(
        title: Text(
          widget.videoTypes!.header ?? "",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: MFGradientBackground(
          verticalPadding: 0, horizontalPadding: 0, child: videoList()),
    ));
  }

  Widget videoList() {
    List<Videos>? videos = widget.videoTypes?.videos;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 160,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 20.0,
      ),
      padding: const EdgeInsets.all(10.0), // padding around the grid
      itemCount: videos?.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () {
              context.pushNamed(Routes.youtubePlayerScreen.name,
                  extra: videos?[index].videoUrl);
            },
            child: YoutubeCard(videos?[index]));
      },
    );
  }
}
