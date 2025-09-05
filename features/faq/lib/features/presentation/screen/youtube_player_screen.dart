import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
// ignore_for_file: must_be_immutable
class YoutubePlayerScreen extends StatefulWidget {
  String? videoUrl;
  YoutubePlayerScreen({this.videoUrl, super.key});

  @override
  State<YoutubePlayerScreen> createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        mute: false,
        showFullscreenButton: true,
        loop: false,
      ),
    );

    _controller.setFullScreenListener(
      (isFullScreen) {
        log('${isFullScreen ? 'Entered' : 'Exited'} Fullscreen.');
      },
    );

    if (widget.videoUrl != null) {
      _controller.loadVideo(widget.videoUrl!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      controller: _controller,
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: Text(getString(lblYoutubeTitle),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.primaryLight,
                      darkColor: AppColors.white,
                    ))),
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.keyboard_backspace,
                color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.primaryLight,
                  darkColor: AppColors.white,
                ),
              ),
            ),
          ),
          body: MFGradientBackground(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (kIsWeb && constraints.maxWidth > 750) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            player,
                            const VideoPositionIndicator(),
                          ],
                        ),
                      ),
                      const Expanded(
                        flex: 2,
                        child: SingleChildScrollView(
                          child: Controls(),
                        ),
                      ),
                    ],
                  );
                }

                return ListView(
                  children: [
                    player,
                    const VideoPositionIndicator(),
                    const Controls(),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}

class Controls extends StatelessWidget {
  ///
  const Controls({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MetaDataSection(),
        ],
      ),
    );
  }

}

///
class VideoPositionIndicator extends StatelessWidget {
  ///
  const VideoPositionIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.ytController;

    return StreamBuilder<YoutubeVideoState>(
      stream: controller.videoStateStream,
      initialData: const YoutubeVideoState(),
      builder: (context, snapshot) {
        final position = snapshot.data?.position.inMilliseconds ?? 0;
        final duration = controller.metadata.duration.inMilliseconds;

        return LinearProgressIndicator(
          value: duration == 0 ? 0 : position / duration,
          minHeight: 1,
        );
      },
    );
  }
}

class MetaDataSection extends StatelessWidget {
  const MetaDataSection({super.key});

  @override
  Widget build(BuildContext context) {
    return YoutubeValueBuilder(
      buildWhen: (o, n) {
        return o.metaData != n.metaData ||
            o.playbackQuality != n.playbackQuality;
      },
      builder: (context, value) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Text('Title', value.metaData.title),
            const SizedBox(height: 10),
            _Text('Channel', value.metaData.author),
            const SizedBox(height: 10),
            _Text(
              'Playback Quality',
              value.playbackQuality ?? '',
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _Text('Video Id', value.metaData.videoId),
                const Spacer(),
                const _Text(
                  'Speed',
                  '',
                ),
                YoutubeValueBuilder(
                  builder: (context, value) {
                    return DropdownButton(
                      value: value.playbackRate,
                      isDense: true,
                      underline: const SizedBox(),
                      items: PlaybackRate.all
                          .map(
                            (rate) => DropdownMenuItem(
                              value: rate,
                              child: Text(
                                '${rate}x',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (double? newValue) {
                        if (newValue != null) {
                          context.ytController.setPlaybackRate(newValue);
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _Text extends StatelessWidget {
  final String title;
  final String value;

  const _Text(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: '$title : ',
        style: Theme.of(context).textTheme.labelLarge,
        children: [
          TextSpan(
            text: value,
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}
