import 'package:ach/config/routes/route.dart';
import 'package:ach/presentation/ach_wireframe/screens/added_banks_screen.dart';
import 'package:ach/presentation/ach_wireframe/screens/awaiting_upi_screen.dart';
import 'package:ach/presentation/ach_wireframe/screens/bank_verify_options_screen.dart';
import 'package:ach/presentation/ach_wireframe/screens/cancel_mandate_screen.dart';
import 'package:ach/presentation/ach_wireframe/screens/enter_bank_details.dart';
import 'package:ach/presentation/ach_wireframe/screens/mandate_success_screen.dart';
import 'package:ach/presentation/ach_wireframe/screens/name_mismatch_screen.dart';
import 'package:ach/presentation/ach_wireframe/screens/select_bank_screen.dart';
import 'package:ach/presentation/ach_wireframe/screens/update_cus_bank_detail.dart';
import 'package:ach/presentation/ach_wireframe/screens/update_mandate_screen.dart';
import 'package:ach/presentation/ach_wireframe/screens/upi_screen.dart';
import 'package:ach/presentation/ach_wireframe/screens/upload_document_screen.dart';
import 'package:ach/presentation/cubit/ach_cubit.dart';
import 'package:common/features/rate_us/presentation/cubit/rate_us_cubit.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:service_ticket/features/presentation/cubit/service_request_cubit.dart';
import '../../presentation/ach_wireframe/screens/view_mandate.dart';

final List<GoRoute> achRoutes = [
  GoRoute(
    path: Routes.addedBanksScreen.path,
    name: Routes.addedBanksScreen.name,
    builder: (context, state) {
      Map<String, dynamic> args = state.extra as Map<String, dynamic>;
      return BlocProvider(
          create: (context) => di<AchCubit>(),
          child: AddedBanksList(
            loanData: args["loanData"]!,
            bankData: args["bankData"]!,
            updateMandateInfo: args["updateMandateInfo"]!,
            source: args["source"],
          ));
    },
  ),
  GoRoute(
    path: Routes.updateCusBankDetail.path,
    name: Routes.updateCusBankDetail.name,
    builder: (context, state) {
      Map<String, dynamic> args = state.extra as Map<String, dynamic>;
      return BlocProvider(
          create: (context) => di<AchCubit>(),
          child: UpdateCusBankDetail(
              loanData: args["loanData"]!,
              bankData: args["bankData"]!,
              verificationMode: args["verificationMode"]!,
              selectedApplicant: args["selectedApplicant"]!,
              updateMandateInfo: args["updateMandateInfo"]!,
              source: args["source"]!));
    },
  ),
  GoRoute(
    path: Routes.selectBankScreen.path,
    name: Routes.selectBankScreen.name,
    builder: (context, state) {
      Map<String, dynamic> args = state.extra as Map<String, dynamic>;
      return BlocProvider(
          create: (context) => di<AchCubit>(),
          child: SelectBankScreen(
            loanData: args["loanData"]!,
            selectedApplicant: args["selectedApplicant"]!,
            updateMandateInfo: args["updateMandateInfo"]!,
            source: args["source"],
          ));
    },
  ),
  GoRoute(
    path: Routes.bankVerifyOptions.path,
    name: Routes.bankVerifyOptions.name,
    builder: (context, state) {
      Map<String, dynamic> args = state.extra as Map<String, dynamic>;
      return BlocProvider(
          create: (context) => di<AchCubit>(),
          child: BankVerifyOptionsScreen(
              loanData: args["loanData"]!,
              bank: args["bankData"]!,
              selectedApplicant: args["selectedApplicant"]!,
              updateMandateInfo: args["updateMandateInfo"]!));
    },
  ),
  GoRoute(
    path: Routes.enterBankDetailsScreen.path,
    name: Routes.enterBankDetailsScreen.name,
    builder: (context, state) {
      Map<String, dynamic> args = state.extra as Map<String, dynamic>;
      return BlocProvider(
          create: (context) => di<AchCubit>(),
          child: EnterBankDetailsScreen(
              loanData: args["loanData"]!,
              selectedBank: args["selectedBank"]!,
              verificationMode: args["verificationMode"]!,
              selectedApplicant: args["selectedApplicant"]!,
              updateMandateInfo: args["updateMandateInfo"]!,
              mandateSource: args["mandateSource"]!,
              source: args["source"]));
    },
  ),
  GoRoute(
      path: Routes.mandateSuccessScreen.path,
      name: Routes.mandateSuccessScreen.name,
      builder: (context, state) {
        Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        return MultiBlocProvider(
          providers: [
            BlocProvider<AchCubit>(
              create: (context) => di<AchCubit>(),
            ),
            BlocProvider<RateUsCubit>(
              create: (context) => di<RateUsCubit>(),
            ),
          ],
          child: MandateSuccessScreen(
              loanData: args["loanData"]!,
              bankName: args["bankName"]!,
              selectedApplicant: args["selectedApplicant"]!,
              accountNumber: args["accountNumber"]!,
              verificationMode: args["verificationMode"]!,
              vpaStatus: args["vpaStatus"]!,
              mandateResponse: args["mandateResponse"]!,
              source: args["source"],
              updateMandateInfo: args["updateMandateInfo"]!),
        );
      }),
  GoRoute(
    path: Routes.nameMismatchScreen.path,
    name: Routes.nameMismatchScreen.name,
    builder: (context, state) {
      Map<String, dynamic> args = state.extra as Map<String, dynamic>;
      return MultiBlocProvider(
          providers: [
            BlocProvider<AchCubit>(
              create: (context) => di<AchCubit>(),
            ),
            BlocProvider<ServiceRequestCubit>(
              create: (context) => di<ServiceRequestCubit>(),
            ),
          ],
          child: NameMismatchScreen(
              loanData: args["loanData"]!,
              selectedBank: args["selectedBank"]!,
              selectedApplicant: args["selectedApplicant"]!,
              verificationMode: args["verificationMode"]!,
              bankAccountDetail: args["bankAccountDetail"]!,
              vpaPayerDetail: args["vpaPayerDetail"]!,
              updateMandateInfo: args["updateMandateInfo"]!));
    },
  ),
  GoRoute(
    path: Routes.uploadDocumentScreen.path,
    name: Routes.uploadDocumentScreen.name,
    builder: (context, state) {
      Map<String, dynamic> args = state.extra as Map<String, dynamic>;
      return BlocProvider(
          create: (context) => di<AchCubit>(),
          child: UploadDocScreen(imagePath: args["imagePath"], updateToS3: args["updateToS3"]));
    },
  ),
  GoRoute(
    path: Routes.upiScreen.path,
    name: Routes.upiScreen.name,
    builder: (context, state) {
      Map<String, dynamic> args = state.extra as Map<String, dynamic>;
      return BlocProvider(
          create: (context) => di<AchCubit>(),
          child: UpiScreen(
              loanData: args["loanData"]!,
              selectedBank: args["selectedBank"]!,
              verificationMode: args["verificationMode"]!,
              selectedApplicant: args["selectedApplicant"]!,
              updateMandateInfo: args["updateMandateInfo"]!));
    },
  ),
  GoRoute(
    path: Routes.awaitingUpi.path,
    name: Routes.awaitingUpi.name,
    builder: (context, state) {
      Map<String, dynamic> args = state.extra as Map<String, dynamic>;
      return BlocProvider(
          create: (context) => di<AchCubit>(),
          child: AwaitingUpiScreen(
              awaitingVPAModel: args["awaitingVPAModel"]!,
              updateMandateInfo: args["updateMandateInfo"]!));
    },
  ),
  GoRoute(
    path: Routes.mandateDetailsScreen.path,
    name: Routes.mandateDetailsScreen.name,
    builder: (context, state) {
      Map<String, dynamic> args = state.extra as Map<String, dynamic>;
      return BlocProvider(
          create: (context) => di<AchCubit>(),
          child: MandatesDetails(loanData: args["loanData"]!));
    },
  ),
  GoRoute(
    path: Routes.updateMadateScreen.path,
    name: Routes.updateMadateScreen.name,
    builder: (context, state) {
      Map<String, dynamic> args = state.extra as Map<String, dynamic>;
      return MultiBlocProvider(
          providers: [
            BlocProvider<AchCubit>(
              create: (context) => di<AchCubit>(),
            ),
            BlocProvider<ServiceRequestCubit>(
              create: (context) => di<ServiceRequestCubit>(),
            ),
          ],
          child: UpdateMandateScreen(
            loanData: args["loanData"]!,
            applicantName: args["applicantName"]!,
            mandateData: args["mandateData"]!,
          ));
    },
  ),
  GoRoute(
    path: Routes.cancelMadateScreen.path,
    name: Routes.cancelMadateScreen.name,
    builder: (context, state) {
      Map<String, dynamic> args = state.extra as Map<String, dynamic>;
      return MultiBlocProvider(
          providers: [
            BlocProvider<AchCubit>(
              create: (context) => di<AchCubit>(),
            ),
            BlocProvider<ServiceRequestCubit>(
              create: (context) => di<ServiceRequestCubit>(),
            ),
          ],
          child: CancelMandateScreen(
              loanData: args["loanData"]!,
              applicantName: args["applicantName"]!,
              mandateData: args["mandateData"]!));
    },
  ),
];
