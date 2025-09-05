

import 'dart:async';
import 'dart:math';
import 'package:common/helper/constant_assets.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/app_dimens.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:faq/config/routes/route.dart';
import 'package:faq/features/data/models/faq_response.dart';
import 'package:faq/features/presentation/cubit/faq_cubit.dart';
import 'package:faq/features/presentation/cubit/faq_state.dart';
import 'package:faq/features/presentation/widgets/common_widgets/search_text_highlighter.dart';
import 'package:faq/features/presentation/widgets/common_widgets/youtube_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FAQsAgruments {
  final bool? isMicClicked;
  final Data? data;

  FAQsAgruments(this.isMicClicked, this.data);
}

class FAQSearchScreen extends StatefulWidget {
  const FAQSearchScreen({super.key, this.data});

  final FAQsAgruments? data;

  @override
  State<FAQSearchScreen> createState() => _FAQSearchScreenState();
}

class _FAQSearchScreenState extends State<FAQSearchScreen> {
  TextEditingController controller = TextEditingController();
  final bool _onDevice = false;
  final TextEditingController _pauseForController =
      TextEditingController(text: '2');
  final TextEditingController _listenForController =
      TextEditingController(text: '30');
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  String _currentLocaleId = '';
  List<LocaleName> localeNames = [];
  final SpeechToText speech = SpeechToText();
  late BuildContext showDialogContext;
  bool canPop = false;

  @override
  void dispose() {
    controller.dispose();
    speech.stop();
    speech.cancel();
    super.dispose();
  }

  @override
  void initState() {
    initSpeechState();
    super.initState();
  }

  Future<void> initSpeechState() async {
    try {
      var hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
        debugLogging: true,
      );
      if (hasSpeech) {
        localeNames = await speech.locales();
        _currentLocaleId = "en_IN";
      }
      if (!mounted) return;
      if (widget.data?.isMicClicked ?? false) {
        startListening();
      }
    } catch (e) {
      debugPrint("EXCEPTION----$e");
    }
  }

  void startListening() async {
    controller.clear();
    lastWords = '';
    lastError = '';
    canPop = false;
    final pauseFor = int.tryParse(_pauseForController.text);
    final listenFor = int.tryParse(_listenForController.text);
    final options = SpeechListenOptions(
        onDevice: _onDevice,
        listenMode: ListenMode.confirmation,
        cancelOnError: true,
        partialResults: true,
        autoPunctuation: true,
        enableHapticFeedback: true);
    await speech.listen(
      onResult: resultListener,
      listenFor: Duration(seconds: listenFor ?? 30),
      pauseFor: Duration(seconds: pauseFor ?? 3),
      localeId: _currentLocaleId,
      onSoundLevelChange: soundLevelListener,
      listenOptions: options,
    );

    if (speech.isListening) {
      if (mounted) {
      showMyDailouge();
      }
    }
  }


  void resultListener(SpeechRecognitionResult result) {
    lastWords = result.recognizedWords;
    controller.text = result.recognizedWords;
    if (controller.text.isNotEmpty) {
      context.read<FAQCubit>().performSearch(widget.data?.data ?? Data(),controller.text);
      closeDialog();
    }
  }

  closeDialog(){
    if(!canPop){
    Navigator.of(showDialogContext).pop();
    }
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    this.level = level;
  }

  void errorListener(SpeechRecognitionError error) {
    lastError = error.errorMsg;
    debugPrint("LAST ERROR----$lastError");
  }

  void statusListener(String status) {
    lastStatus = status;
    debugPrint('Speech Status: $status');
    if (status == "done" || status == "doneNoResult") {
      if (controller.text.isNotEmpty) {
        BlocProvider.of<FAQCubit>(context).performSearch(widget.data?.data ?? Data(),controller.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: customAppbar(
          context: context,
          title: getString(lblFaqSearchResults),
          onPressed: () {
            context.pop();
          }),
      body: MFGradientBackground(
          child: Column(
        children: [
          searchBar(context, speech.isListening),
          searchViewWidget(),
        ],
      )),
    );
  }

  Expanded searchViewWidget() {
    return Expanded(
      child: BlocBuilder<FAQCubit, FAQState>(
          buildWhen: (previous, current) => current is SearchLoaded,
          builder: (context, state) {
            if (state is SearchLoaded) {
              if ((state.results).isEmpty) {
                return noResultFoundWidget(context);
              } else {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      if(state.videos.isNotEmpty)
                      categoryRow(state.videos),
                      Text(
                        getString(lblFAQsTitle),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      showSearchFAQResults(state)
                    ],
                  ),
                );
              }
            }

            return const SizedBox.shrink();
          }),
    );
  }

  Widget categoryRow(List<Videos> videoElement) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              getString(lblFaqSearchVideos),
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
              itemCount: (videoElement).length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (itemContext, index) {
                return GestureDetector(
                    onTap: () {
                      context.pushNamed(Routes.youtubePlayerScreen.name,
                          extra: videoElement[index].videoUrl);
                    },
                    child: YoutubeCard(videoElement[index]));
              },
            )),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }

  Container searchBar(BuildContext context, bool isListening) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: setColorBasedOnTheme(
            context: context,
            lightColor: AppColors.primaryLight6.withOpacity(0.6),
            darkColor: AppColors.cardDark,
          ),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            ImageConstant.searchIcon,
            colorFilter: ColorFilter.mode(
                Theme.of(context).primaryColor, BlendMode.srcIn),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextField(
              autofocus: true,
              onSubmitted: (value) {
                BlocProvider.of<FAQCubit>(context)
                    .performSearch(widget.data?.data ?? Data(), value);
              },
              onChanged: (value) {
                BlocProvider.of<FAQCubit>(context).performSearch(
                  widget.data?.data ?? Data(),
                  value,
                );
              },
              cursorColor: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.primaryLight3,
                  darkColor: AppColors.white),
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: getString(msgFaqSearchHint),
                hintStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.primaryLight3,
                      darkColor: AppColors.white,
                    ),
                    fontSize: 16),
              ),
            ),
          ),
          BlocBuilder<FAQCubit, FAQState>(
            buildWhen: (previous, current) => current is FAQMicActiveState,
            builder: (context, state) {
              if (state is FAQMicActiveState) {
                return GestureDetector(
                    onTap: () {
                      if (state.showMic) {
                        startListening();
                      } else {
                        controller.clear();
                        BlocProvider.of<FAQCubit>(context).searchBarClose();
                      }
                    },
                    child: Icon(state.showMic ? Icons.mic : Icons.close,
                        color: Theme.of(context).primaryColor));
              }
              return const SizedBox.shrink();
            },
          )
        ],
      ),
    );
  }

 void showMyDailouge() {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          showDialogContext = context;
          Timer.periodic(const Duration(seconds: 3), (timer) {
            if (controller.text.isEmpty) {
              if (mounted) {
                canPop = true;
                Navigator.of(context).pop();
              }
            }
            speech.stop();
            speech.cancel();
            timer.cancel();
          });
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.v)),
            elevation: 0.0,
            backgroundColor: Theme.of(context).cardColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.mic,
                    size: 70,
                    color: setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.primaryLight3,
                        darkColor: AppColors.white),
                  ),
                  Text(
                    getString(lblFaqSearchListening),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: setColorBasedOnTheme(
                              context: context,
                              lightColor: AppColors.primaryLight3,
                              darkColor: AppColors.white),
                        ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Padding noResultFoundWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(ConstantAssets.svgNoSearch),
          SizedBox(
            width: 18.h,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16.v,
              ),
              Text(getString(msgFaqSearchNoResultFound),
                  style: Theme.of(context).textTheme.titleSmall),
            ],
          )
        ],
      ),
    );
  }

  Widget showSearchFAQResults(SearchLoaded state) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: (state.results).length,
        itemBuilder: (context, indexFaq) {
          if (state.results[indexFaq].answer != null ||
              (state.results[indexFaq].answer ?? "").isNotEmpty) {
            return Column(
              children: [
                Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    collapsedIconColor: Theme.of(context).highlightColor,
                    iconColor: Theme.of(context).highlightColor,
                    tilePadding: EdgeInsets.zero,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: FAQTitleTextHighlighter(text: state.results[indexFaq].question.toString(),query: controller.text,),
                          ),
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 3.v, bottom: 3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 297.h,
                              margin: EdgeInsets.only(right: 31.h, left: 12),
                              child: Html(
                                  data:
                                      state.results[indexFaq].answer.toString(),
                                  style: {
                                    "body": Style(
                                        fontSize:
                                            FontSize(AppDimens.labelSmall),
                                        fontFamily: "Karla",
                                        fontWeight: FontWeight.w400,
                                        color: setColorBasedOnTheme(
                                            context: context,
                                            lightColor: AppColors.textLight,
                                            darkColor: AppColors.white))
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        });
  }
}