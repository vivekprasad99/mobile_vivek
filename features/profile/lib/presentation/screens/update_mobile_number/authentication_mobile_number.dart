import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:core/config/widgets/mf_appbar.dart';

import 'package:core/utils/size_utils.dart';

import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/config/string_resource/Strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:profile/config/routes/route.dart';
import 'package:profile/data/models/customer_info_args.dart';
import 'package:profile/presentation/cubit/profile_cubit.dart';
import 'package:profile/presentation/screens/components/widgets/fd_select_tile.dart';
import 'package:help/features/utils/help_common_widget.dart';
import 'package:help/features/utils/constant_help.dart';
import 'package:profile/utils/utils.dart';
import '../../../data/models/my_profile_model_request.dart';

class AuthenticateUpdateMobileNumber extends StatefulWidget {
  final String newPhoneNumber;
  final bool isUserToCustomer;
  final CustomerInfoArg customerInfoArg;
  final Operation updateOperation;
  const AuthenticateUpdateMobileNumber({ required this.newPhoneNumber, required this.isUserToCustomer, required this.customerInfoArg, required this.updateOperation ,super.key});

  @override
  State<AuthenticateUpdateMobileNumber> createState() =>
      _AuthenticateUpdateMobileNumberState();
}

class _AuthenticateUpdateMobileNumberState
    extends State<AuthenticateUpdateMobileNumber> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   int _selectedIndex = 0;
   List<NomineeModel> nomineeList = [
    NomineeModel("Aadhaar", false),
     //TODO will be uncomment once digilocker is enable
    // NomineeModel("Digi locker", false),
   
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: customAppbar(
            context: context,
            title: '',
            onPressed: () {
              Navigator.pop(context);
            },
            actions: [HelpCommonWidget(categoryval: HelpConstantData.subCategoryProfile,subCategoryval: HelpConstantData.categoryUpdateMobile),]),
        body: _buildWidget());
  }

  Widget _buildWidget() {
    return MFGradientBackground(
      horizontalPadding: 16.h,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getString(lblAuth),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 20),
            ),
            SizedBox(height: 10.v),
            Text(
              getString(lblVerifyOption),
              style: Theme.of(context).textTheme.labelMedium,
            ),
            SizedBox(height: 20.v),
             ListView.builder(
          itemCount: nomineeList.length,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemBuilder: (context, index) => FDSelectTile(
              isSelected: _selectedIndex == index ? true : false,
              title: nomineeList.elementAt(index).name,
              onTap: () {
                _selectedIndex = index;
                setState(() {});
              })),
            const Spacer(),
            BlocListener<ProfileCubit, ProfileState>(
              listener: (context, state) {
               if(state is ProfileLoadingState){
                 if (state.isloading) {
                   showLoaderDialog(context, getString(lblLoading));
                 } else {
                   Navigator.of(context, rootNavigator: true).pop();
                 }
               } else if(state is MyProfileSuccessState){
                  if(state.response.code==AppConst.codeSuccess){
                    context.pushNamed(
                        Routes.myProfileUpdateMobileNumAadharAuth.name, extra: {"profileInfo": state.response.data, "newPhoneNumber": widget.newPhoneNumber,
                      "customerInfoArg": widget.customerInfoArg, "updateOperation" : widget.updateOperation
                        });
                  } else {
                    toastForFailureMessage(
                        context: context,
                        msg: state.response.responseCode ?? "");
                  }
               } else if(state is MyProfileFailureState){
                 toastForFailureMessage(
                     context: context,
                     msg: getFailureMessage(state.failure));
               }
              },
              child: MfCustomButton(
                  outlineBorderButton: false,
                  isDisabled: false,
                  onPressed: () {
                    BlocProvider.of<ProfileCubit>(context).getMyProfile(MyProfileRequest(
                        ucic: getUCIC(), superAppId: getSuperAppId(), source: AppConst.source));
                  },
                  text: getString(lblContinue)),
            ),
          ],
        ),
      ),
    );
  }
}

class NomineeModel {
  String name;
  bool isClicked;

  NomineeModel(this.name, this.isClicked);
}
