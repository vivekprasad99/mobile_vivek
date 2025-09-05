import 'package:auth/config/routes/route.dart';
import 'package:auth/features/login_and_registration/presentation/cubit/auth_cubit.dart';
import 'package:auth/features/login_and_registration/presentation/cubit/auth_state.dart';
import 'package:auth/features/login_and_registration/presentation/login_wireframe/widgets/custom_pin_code_text_field.dart';
import 'package:common/features/startup/data/models/validate_device_response.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/login_request.dart';
import '../login_wireframe/widgets/custom_elevated_button.dart';
import 'package:help/features/utils/help_common_widget.dart';
import 'package:help/features/utils/constant_help.dart';

class OldMPINScreen extends StatefulWidget {
  const OldMPINScreen({super.key});

  @override
  State<OldMPINScreen> createState() => _OldMPINScreenState();
}

class _OldMPINScreenState extends State<OldMPINScreen> {
  String? errorText;
  bool enableMpinBtn = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _mPinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
     return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 64.h,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: Theme.of(context).highlightColor),
              onPressed: () {
                context.pop();
              }),
          elevation: 0.0,
          actions: [HelpCommonWidget(categoryval: HelpConstantData.categoryRegistration,subCategoryval: HelpConstantData.subCategoryMpin)],
        ),
        body: SizedBox(
          width: SizeUtils.width,
          child: Form(
                key: _formKey,
                child: MFGradientBackground(
                  horizontalPadding: 16.h,
                  verticalPadding: 1.v,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.v),
                      Text(getString(lblEnterCorrectMpin),style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
                      ),
                      SizedBox(height: 20.v),
                      Text(getString(lblEnter4DigitMpin),
                          style: Theme.of(context)
                              .textTheme.bodySmall?.copyWith(
                            color: setColorBasedOnTheme(
                              context: context,
                              lightColor: AppColors.primaryLight,
                              darkColor: AppColors.secondaryLight5,
                            )
                          ),
                      ),
                      SizedBox(height: 10.v),

                      SizedBox(
                        width: 240.h,
                        child: CustomPinCodeTextField(
                            length: 4,
                            alignment: Alignment.topLeft,
                            textStyle: Theme.of(context).textTheme.titleSmall,
                            context: context,
                            controller: _mPinController,
                            onChanged: (value) {
                              if(value.isNotEmpty && value.length < 4){
                                BlocProvider.of<AuthCubit>(context)
                                    .validateMPINButton(false);
                              } else {
                                BlocProvider.of<AuthCubit>(context)
                                    .validateMPINButton(true);
                              }
                              return null;
                            }),
                      ),
                      SizedBox(height: 22.v),
                      const Expanded(child: SizedBox()),
                      _buildMPINButton(),
                      SizedBox(height: 20.v),
                      Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom))
                    ],
                  ),
                ),
              )
        ),
      ),
    );
  }


  Widget _buildMPINButton() {

    return BlocConsumer<AuthCubit, AuthState>(buildWhen: (context, state) {
      return state is AuthInitialState ||
          state is MPINValidateState || state is LoginSuccessState || state is LoginFailureState;
    }, listener: (context, state) {
      if (state is MPINValidateState) {
        enableMpinBtn = state.isValid;
      } else if (state is LoginSuccessState) {
        if (state.response.code == AppConst.codeSuccess) {
          PrefUtils.saveInt(PrefUtils.keyAuthNavFlow, AuthNavFlow.changeMpin.value);
          context.pushReplacementNamed(Routes.mpin.name, extra: Profiles());
        } else if (state.response.code == AppConst.codeFailure) {
          toastForFailureMessage(
              context: context,
              msg: getString(state.response.responseCode ?? msgSomethingWentWrong),
              bottomPadding: 40.v);
        }
      } else if (state is LoginFailureState) {
        toastForFailureMessage(
            context: context,
            msg: getFailureMessage(state.error),
            bottomPadding: 40.v);
      } else if (state is LoadingState) {
        if (state.isloading) {
          showLoaderDialog(context, getString(lblLoginLoading));
        } else {
          Navigator.of(context, rootNavigator: true).pop();
        }
      }
    }, builder: (context, state) {
      return AbsorbPointer(
          absorbing: !enableMpinBtn,
          child: Align(
              alignment: Alignment.center,
              child: CustomElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    final loginRequest = LoginRequest(
                        mPin: _mPinController.text,
                        superAppId: getSuperAppId(),source: AppConst.source);
                    BlocProvider.of<AuthCubit>(context)
                        .login(loginRequest: loginRequest, isFromDeleteProfile: false);
                  }
                },
                width: double.maxFinite,
                text: (state is LoadingState && state.isloading)
                    ? getString(lblVerifying)
                    : getString(lblLoginVerify),
                margin: EdgeInsets.symmetric(horizontal: 3.h),
                buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: enableMpinBtn
                        ? Theme.of(context).highlightColor
                        : Theme.of(context).disabledColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.h),
                    )),
                buttonTextStyle: enableMpinBtn
                    ? Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.white)
                    : Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).unselectedWidgetColor),

              )));
    });
  }

  @override
  void dispose() {
    _mPinController.dispose();
    super.dispose();
  }
}
