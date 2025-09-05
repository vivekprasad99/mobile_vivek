import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:faq/features/data/models/faq_response.dart';
import 'package:flutter/material.dart';
// ignore_for_file: must_be_immutable
class YoutubeCard extends StatefulWidget {
  YoutubeCard(this.video, {super.key});

  Videos? video;

  @override
  State<YoutubeCard> createState() => _YoutubeCardState();
}

class _YoutubeCardState extends State<YoutubeCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
          color: setColorBasedOnTheme(context: context, lightColor: AppColors.primaryLight6, darkColor: AppColors.cardDark),
          borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 148.0,
                  height: 88.0,

                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.video?.thumbnail ?? "",
                      ),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.5),
                          BlendMode.darken),
                    ),
                  ),
                ),
                const Icon(Icons.play_circle_outline,
                    color: Colors.white)
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.only(left: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.video!.title!,overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
