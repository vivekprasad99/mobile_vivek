import 'dart:async';
import 'dart:math';
import 'package:common/features/search/data/model/search_request.dart';
import 'package:common/features/search/presentation/cubit/search_cubit.dart';
import 'package:common/features/search/presentation/screen/widgets/cms_search_view.dart';
import 'package:common/features/search/presentation/screen/widgets/no_result_found.dart';
import 'package:common/features/search/presentation/screen/widgets/products_view_bucket.dart';
import 'package:common/features/search/presentation/screen/widgets/recommended_recent_view.dart';
import 'package:common/features/search/presentation/screen/widgets/services_view_bucket.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:product/presentation/utils/image_constant.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.isMicClicked});

  final bool? isMicClicked;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController controller = TextEditingController();
  final bool _onDevice = false;
  final TextEditingController _pauseForController =
      TextEditingController(text: '5');
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
  bool enableButton = false;

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
      if (widget.isMicClicked ?? false) {
        startListening();
      }
    } catch (e) {
      debugPrint("EXCEPTION----$e");
    }
  }

  void startListening() async {
    canPop = false;
    controller.clear();
    lastWords = '';
    lastError = '';
    final pauseFor = int.tryParse(_pauseForController.text);
    final listenFor = int.tryParse(_listenForController.text);
    final options = SpeechListenOptions(
        onDevice: _onDevice,
        listenMode: ListenMode.confirmation,
        cancelOnError: true,
        partialResults: true,
        autoPunctuation: true,
        enableHapticFeedback: true,);
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
      context.read<SearchCubit>().onQueryChanged(controller.text);
      closeDialog();
    }
  }

  closeDialog() {
    if (!canPop) {
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
        context.read<SearchCubit>().onQueryChanged(controller.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: customAppbar(
          context: context,
          title: getString(lblSearchResults),
          onPressed: () {
            Navigator.of(context).pop();
          },),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
        child: BlocBuilder<SearchCubit, SearchState>(
          buildWhen: (previous, current) => current  is SearchButtonEnableState,
          builder: (context, state) {
            if(state is SearchButtonEnableState){
              enableButton = state.searchEnable ?? false;
            }
            return MfCustomButton(
              buttonColor: setColorBasedOnTheme(
                  context: context,
                  lightColor: enableButton
                      ? AppColors.secondaryLight
                      : AppColors.primaryLight5,
                  darkColor: enableButton
                      ? AppColors.secondaryLight
                      : AppColors.shadowDark),
              text: getString(lblSearch),
              outlineBorderButton: false,
              onPressed: () {
                if(enableButton){
                FocusManager.instance.primaryFocus?.unfocus();
                context.read<SearchCubit>().onSearch(controller.text);
                context.read<SearchCubit>().getSearchRoute(
                    SearchRequest(searchQuery: controller.text));
                }
              },
            );
          },
        ),
      ),
      body: MFGradientBackground(
          child: Column(
        children: [
          searchBar(context, speech.isListening),
          searchViewWidget(),
        ],
      ),),
    );
  }

  Expanded searchViewWidget() {
    return Expanded(
      child: BlocBuilder<SearchCubit, SearchState>(builder: (context, state) {
        if (state is SearchRecentRecommendedFailureState ||
            state is GetSearchRouteFailureState) {
          return Center(
            child: Text(getString(lblSearchErrorGeneric)),
          );
        }
        if (state is LoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is GetSearchRouteSuccessState) {
          if ((state.productsList).isEmpty) {
            return NoResultsFoundWidget(
                searchTitle: getString(msgSearchNoResultFound));
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.v,
                ),
                Expanded(
                  child: CMSSearchViewWidget(
                    state: state,
                    query: controller.text,
                  ),
                ),
                NoResultsFoundWidget(
                searchTitle: getString(msgSearchResultNotFound),
              )
              ],
            );
          }
        }
        if (state is SearchRecentRecommendedState) {
          if (state.isFromPref ?? false) {
            return RecommendedRecentViewWidget(state: state);
          } else {
            if (state.response?.code == AppConst.codeSuccess) {
              return RecommendedRecentViewWidget(state: state);
            } else {
              toastForFailureMessage(
                  context: context,
                  msg: getString(
                      state.response?.responseCode ?? msgSomethingWentWrong,),);
            }
          }
        }
        if (state is UpdateSearchSuggestionList) {
          if (state.data.isEmpty) {
            return NoResultsFoundWidget(
              searchTitle: getString(msgSearchNoResultFound),
            );
          }
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top:24.0),
                  child: typeAheadSearchView(context,state),
                ),
              ),
              NoResultsFoundWidget(searchTitle: getString(msgSearchResultNotFound),),
            ],
          );
        }
        return const SizedBox.shrink();
      },),
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
          borderRadius: BorderRadius.circular(12),),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            ImageConstant.searchIcon,
            colorFilter: ColorFilter.mode(
                Theme.of(context).primaryColor, BlendMode.srcIn,),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextField(
              autofocus: true,
              onSubmitted: (value) {
                context.read<SearchCubit>().onSearch(controller.text);
                context
                    .read<SearchCubit>()
                    .getSearchRoute(SearchRequest(searchQuery: value));
              },
              onChanged: (value){
                context.read<SearchCubit>().onTextChanged(value);
                context.read<SearchCubit>().onQueryChanged(value);
              },
              cursorColor: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.primaryLight3,
                  darkColor: AppColors.white,),
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: getString(msgSearchHint),
                hintStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.primaryLight3,
                      darkColor: AppColors.white,
                    ),
                    fontSize: 16,),
              ),
            ),
          ),
          BlocBuilder<SearchCubit, SearchState>(
            buildWhen: (previous, current) =>
                current is SearchRecentRecommendedState,
            builder: (context, state) {
              if (state is SearchRecentRecommendedState) {
                return GestureDetector(
                    onTap: () {
                      if (state.showMic) {
                        startListening();
                      } else {
                        controller.clear();
                        context.read<SearchCubit>().searchBarClose();
                      }
                    },
                    child: Icon(state.showMic ? Icons.mic : Icons.close,
                        color: Theme.of(context).primaryColor,),);
              }
              return const SizedBox.shrink();
            },
          ),
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
                Navigator.of(showDialogContext).pop();
              }
            }
            speech.stop();
            speech.cancel();
            timer.cancel();
          });
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.v),),
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
                        darkColor: AppColors.white,),
                  ),
                  Text(
                    getString(lblSearchListening),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: setColorBasedOnTheme(
                              context: context,
                              lightColor: AppColors.primaryLight3,
                              darkColor: AppColors.white,),
                        ),
                  ),
                ],
              ),
            ),
          );
        },);
  }

  Widget typeAheadSearchView(
      BuildContext context, UpdateSearchSuggestionList state,) {
    return SingleChildScrollView(
      child: state.showServices ?? false
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((state.servicesList ?? []).isNotEmpty)
                  ServicesViewBucketWidget(
                      query: controller.text, state: state),
                if ((state.productsList ?? []).isNotEmpty)
                  ProductsViewBucketWidget(
                      query: controller.text, state: state),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((state.productsList ?? []).isNotEmpty)
                  ProductsViewBucketWidget(
                      query: controller.text, state: state),
                if ((state.servicesList ?? []).isNotEmpty)
                  ServicesViewBucketWidget(
                      query: controller.text, state: state),
              ],
            ),
    );
  }
}
