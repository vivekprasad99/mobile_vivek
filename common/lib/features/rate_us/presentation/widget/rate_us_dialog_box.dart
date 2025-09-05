import 'package:common/features/rate_us/data/models/rate_us_model.dart';
import 'package:common/features/rate_us/data/models/update_rate_us_request.dart';
import 'package:common/features/rate_us/presentation/cubit/rate_us_cubit.dart';
import 'package:common/features/rate_us/presentation/widget/thanks_feedback_dialog_box.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/common_widgets/mf_custom_text_field.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_review/in_app_review.dart';

class RateUsDialogBox extends StatelessWidget {
  final String? feature;
  final Function(BuildContext dialogContex)? onTap;

  RateUsDialogBox(this.feature,{this.onTap,super.key});

  final TextEditingController _feedbackController = TextEditingController();
  final InAppReview inAppReview = InAppReview.instance;

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    return BlocListener<RateUsCubit, RateUsState>(
      listener: (context, state) async{
        if (state is UpdateRateUsRecordSuccessState &&
            (!state.isComingFromCloseButton!)) {
          if (state.response.code == AppConst.codeSuccess) {
            if (state.isCustomerHappy ?? false) {
              if (await inAppReview.isAvailable()) {
                inAppReview.requestReview().then((value) => onTap!(context));
              }else{
                onTap!(context);
              }
            } else {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return  ThanksFeedbackDialogBox((BuildContext dialogContex){
                    onTap!(dialogContex);
                  });
                },
              );
            }
          }else {
            toastForFailureMessage(
                context: context,
                msg: getString(
                    state.response.responseCode ?? msgSomethingWentWrong,),);
          }
        } else if (state is RateUsFailureState) {
          showSnackBar(
              context: context, message: getFailureMessage(state.failure),);
        } else if (state is UpdateRateUsRecordSuccessState && state.isComingFromCloseButton!) {
          onTap!(context);
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.v)),
        elevation: 0.0,
        backgroundColor: Theme.of(context).cardColor,
        child: dialogContent(context, brightness),
      ),
    );
  }

  Widget dialogContent(BuildContext context, Brightness brightness) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(12.v),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCloseButton(context),
            Text(getString(msgYourFeedbackSubTitle),
                style: Theme.of(context).textTheme.titleMedium,),
            SizedBox(height: 16.h),
            _buildRateUsList(brightness),
            _buildFeedbackTextField(context),
            SizedBox(height: 16.h),
            _buildSubmitButton(context),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  Widget _buildRateUsList(Brightness brightness) {
    List<RateUsModel>? rateUsModelList;
    return SizedBox(
      height: 70.h,
      child: Center(
        child: BlocBuilder<RateUsCubit, RateUsState>(
          buildWhen: (prev, curr) {
            return prev != curr;
          },
          builder: (context, state) {
            if (state is ChangeRateUsState) {
              rateUsModelList = state.rateUsModelList;
            }
            return ListView.separated(
              itemCount: rateUsModelList?.length ?? 0,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                RateUsModel? rateUsModel = rateUsModelList?[index];
                return _buildSmile(
                    context,
                    brightness,
                    (rateUsModelList?[index].isSelected ?? false)
                        ? rateUsModel?.fillColorImage ?? ""
                        : rateUsModel?.image ?? "",
                    rateUsModel?.description ?? "",
                    index,
                    rateUsModelList,);
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: 20.v,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSmile(
      BuildContext context,
      Brightness brightness,
      String lightImg,
      String sentiment,
      int index,
      List<RateUsModel>? rateUsModelList,) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            BlocProvider.of<RateUsCubit>(context).updateRateUs(index);
            BlocProvider.of<RateUsCubit>(context)
                .getRateUsModel(rateUsModelList![index]);
          },
          child: SvgPicture.asset(
            lightImg,
            colorFilter: ColorFilter.mode(
                setColorBasedOnTheme(
                    context: context,
                    lightColor: (rateUsModelList?[index].isSelected ?? false)
                        ? AppColors.secondaryLight
                        : AppColors.primaryLight,
                    darkColor: (rateUsModelList?[index].isSelected ?? false)
                        ? AppColors.white
                        : AppColors.disableTextDark,),
                BlendMode.srcIn,),
          ),
        ),
        SizedBox(height: 4.h),
        Text(getString(sentiment),
            style: Theme.of(context).textTheme.labelSmall,),
      ],
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed: () {
          BlocProvider.of<RateUsCubit>(context).clearRateUsList();
          UpdateRateUsRequest updateRateUsRequest = UpdateRateUsRequest(
              superAppId: getSuperAppId(), feature: feature,);
          BlocProvider.of<RateUsCubit>(context)
              .updateRateUsRecord(updateRateUsRequest, true,false);
        },
        icon: Icon(
          Icons.close,
          color: setColorBasedOnTheme(
              context: context,
              lightColor: AppColors.secondaryLight,
              darkColor: AppColors.white,),
          size: 20.h,
        ),
      ),
    );
  }

  Widget _buildFeedbackTextField(BuildContext context) {
    String? currentSentiment;
    return BlocBuilder<RateUsCubit, RateUsState>(
      buildWhen: (prev, curr) {
        return prev != curr;
      },
      builder: (context, state) {
        if (state is GetRateUsModel) {
          currentSentiment = state.rateUsModel.description;
        }
        return Visibility(
          visible: (currentSentiment ?? "") != labelHappy &&
              (currentSentiment?.isNotEmpty ?? false),
          child: MfCustomFloatingTextField(
            maxLines: 6,
            minLines: 1,
            textInputType: TextInputType.multiline,
            controller: _feedbackController,
            textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.textLight,
                  darkColor: AppColors.white,
                ),),
            labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.primaryLight,
                  darkColor: AppColors.white,
                ),),
            labelText: getString(labelYourFeedback),
            textInputAction: TextInputAction.next,
            borderDecoration: UnderlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(
                color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.primaryLight,
                  darkColor: AppColors.white,
                ),
                width: 1,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    bool? isEnabled;
    String? currentSentiment;
    RateUsModel? rateUsModel;
    return BlocBuilder<RateUsCubit, RateUsState>(
      buildWhen: (prev, curr) {
        return prev != curr;
      },
      builder: (context, state) {
        if (state is GetRateUsModel) {
          isEnabled = state.rateUsModel.description?.isNotEmpty;
          currentSentiment = state.rateUsModel.description;
        }
        if (state is GetRateUsModel) {
          rateUsModel = state.rateUsModel;
        }
        return MfCustomButton(
          leftIcon: (state is LoadingState && state.isloading) ? true : false,
          text: getString(labelSubmit),
          outlineBorderButton: false,
          isDisabled: !(isEnabled ?? false),
          onPressed: () async {
            if (currentSentiment == labelHappy) {
              saveFeedback(rateUsModel, context, true);
            } else {
              saveFeedback(rateUsModel, context, false);
            }
          },
        );
      },
    );
  }

  void saveFeedback(RateUsModel? rateUsModel, BuildContext context,
      bool isCustomerHappy,) async {
    UpdateRateUsRequest updateRateUsRequest = UpdateRateUsRequest(
        superAppId: getSuperAppId(),
        feature: feature,
        rating: rateUsModel?.ratingNum,
        comment: _feedbackController.text,);
    BlocProvider.of<RateUsCubit>(context)
        .updateRateUsRecord(updateRateUsRequest, false, isCustomerHappy);
  }
}
