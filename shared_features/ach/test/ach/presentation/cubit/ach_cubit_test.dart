import 'package:ach/config/ach_const.dart';
import 'package:ach/data/models/get_preset_uri_request.dart';
import 'package:ach/data/models/validate_vpa_req.dart';
import 'package:ach/data/models/validate_vpa_resp.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ach/data/models/create_sr_cancel_mandate_req.dart';
import 'package:ach/data/models/create_sr_cancel_mandate_res.dart';
import 'package:ach/data/models/create_sr_hold_mandate_req.dart';
import 'package:ach/data/models/create_sr_hold_mandate_res.dart';
import 'package:ach/data/models/fetch_bank_accoun_response.dart';
import 'package:ach/data/models/fetch_bank_account_req.dart';
import 'package:ach/data/models/generate_mandate_request.dart';
import 'package:ach/data/models/generate_mandate_response.dart';
import 'package:ach/data/models/generate_sr_req.dart';
import 'package:ach/data/models/generate_sr_resp.dart';
import 'package:ach/data/models/get_ach_loans_request.dart';
import 'package:ach/data/models/get_ach_loans_response.dart';
import 'package:ach/data/models/get_bank_list_resp.dart';
import 'package:ach/data/models/get_cancel_mandate_response.dart';
import 'package:ach/data/models/get_mandate_req.dart';
import 'package:ach/data/models/get_mandate_res.dart';
import 'package:ach/data/models/get_preset_uri_response.dart';
import 'package:ach/data/models/penny_drop_req.dart';
import 'package:ach/data/models/penny_drop_resp.dart';
import 'package:ach/data/models/reactive_mandate_req.dart';
import 'package:ach/data/models/reactive_mandate_res.dart';
import 'package:ach/data/models/submit_update_madate_reason_res.dart';
import 'package:ach/data/models/submit_update_mandate_reason_req.dart';
import 'package:ach/data/models/update_enach_request.dart';
import 'package:ach/data/models/update_enach_response.dart';
import 'package:ach/data/models/update_mandate_reason_resp.dart';
import 'package:ach/domain/usecases/ach_usecase.dart';
import 'package:ach/presentation/cubit/ach_cubit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'ach_cubit_test.mocks.dart';

@GenerateMocks([AchUsecase])
void main() async {
  late AchCubit cubit;
  var mockAchUseCase = MockAchUsecase();
  var mockError = const ServerFailure('some error');
  var mockgetAchLoansRequest = GetAchLoansRequest(ucic: "1234");
  var mockgetAchLoansResponse = [GetAchLoansResponse()];
  var mockFetchBankAccountRequest =
      FetchBankAccountRequest(loanAccountNumber: "123", ucic: "123");
  var mockFetchBankAccountResponse = const FetchBankAccountResponse();
  var mockGetBankListResponse = const GetBankListResponse();
  var mockGetMandateRequest = GetMandateRequest();
  var mockGetMandateResponse = GetMandateResponse();
  var mockPennyDropReq = PennyDropReq();
  var mockPennyDropResponse = PennyDropResponse();
  var mockGenerateMandateRequest = GenerateMandateRequest();
  var mockGenerateMandateResponse = GenerateMandateResponse();
  var mockGetCancelMandateReasonResponse = <GetCancelMandateReasonResponse>[];
  var mockGetPresetUriResponse = GetPresetUriResponse();
  var mockGenerateSrRequest = GenerateSrRequest();
  var mockGenerateSrResponse = GenerateSrResponse();
  var mockSubmitUpdateMandateReasonReq = SubmitUpdateMandateReasonReq();
  var mockSubmitUpdateMandateResponse = SubmitUpdateMandateResponse();
  var mockUpdateEnachStatusRequest = UpdateEnachStatusRequest();
  var mockUpdateEnachStatusResponse = UpdateEnachStatusResponse();
  var mockCreateSrCancelMandateReq = CreateSrCancelMandateReq();
  var mockCreateSrCancelMandateRes = CreateSrCancelMandateRes();
  var mockCreateSrHoldMandateReq = CreateSrHoldMandateReq();
  var mockCreateSrHoldMandateRes = CreateSrHoldMandateRes();
  var mockReactiveMandateReq = ReactiveMandateReq();
  var mockReactiveMandateRes = ReactiveMandateRes();
  var mockUpdateMandateReasonResp = <UpdateMandateReasonResp>[];
  var mockValidateVpaReq = ValidateVpaReq(vpa: "abc@okaxis");
  var mockValidateVpaResp = ValidateVpaResp();
  var mockPresetUriRequest = GetPresetUriRequest();

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    cubit = AchCubit(usecase: mockAchUseCase);
  });
  group('test getloanslist', () {
    blocTest(
      'should emit GetLoansListSuccessState',
      build: () {
        when(mockAchUseCase.call(mockgetAchLoansRequest))
            .thenAnswer((_) async => Right(mockgetAchLoansResponse));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.getLoansList(mockgetAchLoansRequest);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        GetLoansListSuccessState(response: mockgetAchLoansResponse),
      ],
    );

    blocTest(
      'should emit GetLoansListFailureState when get ach loans is called with failure',
      build: () {
        when(mockAchUseCase.call(mockgetAchLoansRequest))
            .thenAnswer((_) async => Left(mockError));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.getLoansList(mockgetAchLoansRequest);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        GetLoansListFailureState(failure: mockError)
      ],
    );

    blocTest(
      'should emit GetLoansListFailureState when get ach loans is called and thrown exception',
      build: () {
        when(mockAchUseCase.call(mockgetAchLoansRequest))
            .thenThrow((_) async => Exception('some error'));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.getLoansList(mockgetAchLoansRequest);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        GetLoansListFailureState(failure: NoDataFailure()),
      ],
    );
  });
  group('test fetchBankAccount', () {
    blocTest(
      'should emit FetchBankAccountSuccessState',
      build: () {
        when(mockAchUseCase.fetchBankAccount(mockFetchBankAccountRequest))
            .thenAnswer((_) async => Right(mockFetchBankAccountResponse));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.fetchBankAccount(mockFetchBankAccountRequest);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        FetchBankAccountSuccessState(response: mockFetchBankAccountResponse),
      ],
    );

    blocTest(
      'should emit FetchBankAccountFailureState when fetch bank accounts is called with failure',
      build: () {
        when(mockAchUseCase.fetchBankAccount(mockFetchBankAccountRequest))
            .thenAnswer((_) async => Left(mockError));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.fetchBankAccount(mockFetchBankAccountRequest);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        FetchBankAccountFailureState(failure: mockError),
      ],
    );

    blocTest(
      'should emit FetchBankAccountFailureState when fetch bank accounts is called and thrown exception',
      build: () {
        when(mockAchUseCase.fetchBankAccount(mockFetchBankAccountRequest))
            .thenThrow((_) async => Exception('some error'));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.fetchBankAccount(mockFetchBankAccountRequest);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        FetchBankAccountFailureState(failure: NoDataFailure()),
      ],
    );
  });
  group('test getBankList', () {
    blocTest(
      'should emit GetBankListSuccessState',
      build: () {
        when(mockAchUseCase.getBankList())
            .thenAnswer((_) async => Right(mockGetBankListResponse));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.getBankList();
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        GetBankListSuccessState(response: mockGetBankListResponse),
      ],
    );

    blocTest(
      'should emit GetBankListFailureState when getBankList is called with failure',
      build: () {
        when(mockAchUseCase.getBankList())
            .thenAnswer((_) async => Left(mockError));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.getBankList();
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        GetBankListFailureState(failure: mockError),
      ],
    );

    blocTest(
      'should emit GetBankListFailureState when getBankList is called and thrown exception',
      build: () {
        when(mockAchUseCase.getBankList())
            .thenThrow((_) async => Exception('some error'));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.getBankList();
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        GetBankListFailureState(failure: NoDataFailure()),
      ],
    );
  });
  group('test getMandates', () {
    blocTest(
      'should emit GetMandatesSuccessState',
      build: () {
        when(mockAchUseCase.getMandates(mockGetMandateRequest))
            .thenAnswer((_) async => Right(mockGetMandateResponse));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.getMandates(mockGetMandateRequest);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        GetMandatesSuccessState(response: mockGetMandateResponse),
      ],
    );

    blocTest(
      'should emit GetMandatesFailureState when getMandates is called with failure',
      build: () {
        when(mockAchUseCase.getMandates(mockGetMandateRequest))
            .thenAnswer((_) async => Left(mockError));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.getMandates(mockGetMandateRequest);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        GetMandatesFailureState(failure: mockError),
      ],
    );

    blocTest(
      'should emit GetMandatesFailureState when getMandates is called and thrown exception',
      build: () {
        when(mockAchUseCase.getMandates(mockGetMandateRequest))
            .thenThrow((_) async => Exception('some error'));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.getMandates(mockGetMandateRequest);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        GetMandatesFailureState(failure: NoDataFailure()),
      ],
    );
  });
  group('test pennyDrop', () {
    blocTest(
      'should emit PennyDropSuccessState',
      build: () {
        when(mockAchUseCase.pennyDrop(mockPennyDropReq))
            .thenAnswer((_) async => Right(mockPennyDropResponse));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.pennyDrop(mockPennyDropReq);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        PennyDropSuccessState(response: mockPennyDropResponse),
      ],
    );

    blocTest(
      'should emit PennyDropFailureState when pennyDrop is called with failure',
      build: () {
        when(mockAchUseCase.pennyDrop(mockPennyDropReq))
            .thenAnswer((_) async => Left(mockError));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.pennyDrop(mockPennyDropReq);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        PennyDropFailureState(failure: mockError),
      ],
    );

    blocTest(
      'should emit PennyDropFailureState when pennyDrop is called and thrown exception',
      build: () {
        when(mockAchUseCase.pennyDrop(mockPennyDropReq))
            .thenThrow((_) async => Exception('some error'));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.pennyDrop(mockPennyDropReq);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        PennyDropFailureState(failure: NoDataFailure()),
      ],
    );
  });
  group('test generateMandateReq', () {
    blocTest(
      'should emit GenerateMandateReqSuccessState',
      build: () {
        when(mockAchUseCase.generateMandateReq(mockGenerateMandateRequest))
            .thenAnswer((_) async => Right(mockGenerateMandateResponse));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.generateMandateReq(mockGenerateMandateRequest);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        GenerateMandateReqSuccessState(response: mockGenerateMandateResponse),
      ],
    );

    blocTest(
      'should emit GenerateMandateReqFailureState when generateMandateReq is called with failure',
      build: () {
        when(mockAchUseCase.generateMandateReq(mockGenerateMandateRequest))
            .thenAnswer((_) async => Left(mockError));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.generateMandateReq(mockGenerateMandateRequest);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        GenerateMandateReqFailureState(failure: mockError),
      ],
    );

    blocTest(
      'should emit GenerateMandateReqFailureState when generateMandateReq is called and thrown exception',
      build: () {
        when(mockAchUseCase.generateMandateReq(mockGenerateMandateRequest))
            .thenThrow((_) async => Exception('some error'));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.generateMandateReq(mockGenerateMandateRequest);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        GenerateMandateReqFailureState(failure: NoDataFailure()),
      ],
    );
  });
  group('test getCancelMandateReason', () {
    blocTest(
      'should emit GetCancelMandateReasonSuccessState',
      build: () {
        when(mockAchUseCase.getCancelMandateReason())
            .thenAnswer((_) async => Right(mockGetCancelMandateReasonResponse));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.getCancelMandateReason();
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        GetCancelMandateReasonSuccessState(
            response: mockGetCancelMandateReasonResponse),
      ],
    );

    blocTest(
      'should emit GetCancelMandateReasonFailureState when getCancelMandateReason is called with failure',
      build: () {
        when(mockAchUseCase.getCancelMandateReason())
            .thenAnswer((_) async => Left(mockError));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.getCancelMandateReason();
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        GetCancelMandateReasonFailureState(failure: mockError),
      ],
    );

    blocTest(
      'should emit GetCancelMandateReasonFailureState when getCancelMandateReason is called and thrown exception',
      build: () {
        when(mockAchUseCase.getCancelMandateReason())
            .thenThrow((_) async => Exception('some error'));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.getCancelMandateReason();
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        GetCancelMandateReasonFailureState(failure: NoDataFailure()),
      ],
    );
  });

  group('test getPresetUri', () {
    blocTest(
      'should emit GGetPresetUriResponseSuccessState',
      build: () {
        when(mockAchUseCase.getPresetUri(mockPresetUriRequest))
            .thenAnswer((_) async => Right(mockGetPresetUriResponse));
        return cubit;
      },
      act: (AchCubit cubit) {
        // cubit.getPresetUri();
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        GetPresetUriResponseSuccessState(response: mockGetPresetUriResponse, useCase: AchConst.deleteDocument),
      ],
    );

    blocTest(
      'should emit GetPresetUriResponseFailureState when getPresetUri is called with failure',
      build: () {
        when(mockAchUseCase.getPresetUri(mockPresetUriRequest))
            .thenAnswer((_) async => Left(mockError));
        return cubit;
      },
      act: (AchCubit cubit) {
        // cubit.getPresetUri();
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        GetPresetUriResponseFailureState(failure: mockError),
      ],
    );

    blocTest(
      'should emit GetPresetUriResponseFailureState when getPresetUri is called and thrown exception',
      build: () {
        when(mockAchUseCase.getPresetUri(mockPresetUriRequest))
            .thenThrow((_) async => Exception('some error'));
        return cubit;
      },
      act: (AchCubit cubit) {
        // cubit.getPresetUri();
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        GetPresetUriResponseFailureState(failure: NoDataFailure()),
      ],
    );
  });
  group('test generateSR', () {
    blocTest(
      'should emit GenerateSRSuccessState',
      build: () {
        when(mockAchUseCase.generateSR(mockGenerateSrRequest))
            .thenAnswer((_) async => Right(mockGenerateSrResponse));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.generateSR(mockGenerateSrRequest);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        GenerateSRSuccessState(response: mockGenerateSrResponse),
      ],
    );

    blocTest(
      'should emit GenerateSRFailureState when generateSR is called with failure',
      build: () {
        when(mockAchUseCase.generateSR(mockGenerateSrRequest))
            .thenAnswer((_) async => Left(mockError));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.generateSR(mockGenerateSrRequest);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        GenerateSRFailureState(failure: mockError),
      ],
    );

    blocTest(
      'should emit GenerateSRFailureState when generateSR is called and thrown exception',
      build: () {
        when(mockAchUseCase.generateSR(mockGenerateSrRequest))
            .thenThrow((_) async => Exception('some error'));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.generateSR(mockGenerateSrRequest);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        GenerateSRFailureState(failure: NoDataFailure()),
      ],
    );
  });
  group('test submitUpdateMandateReason', () {
    blocTest(
      'should emit SubmitUpdateMandateResponseSuccessState',
      build: () {
        when(mockAchUseCase
                .submitUpdateMandateReason(mockSubmitUpdateMandateReasonReq))
            .thenAnswer((_) async => Right(mockSubmitUpdateMandateResponse));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.submitUpdateMandateReason(mockSubmitUpdateMandateReasonReq);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        SrUpdateLoadingState(),
        SubmitUpdateMandateResponseSuccessState(
            response: mockSubmitUpdateMandateResponse),
      ],
    );

    blocTest(
      'should emit SubmitUpdateMandateResponseFailureState when submitUpdateMandateReason is called with failure',
      build: () {
        when(mockAchUseCase
                .submitUpdateMandateReason(mockSubmitUpdateMandateReasonReq))
            .thenAnswer((_) async => Left(mockError));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.submitUpdateMandateReason(mockSubmitUpdateMandateReasonReq);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        SrUpdateLoadingState(),
        SubmitUpdateMandateResponseFailureState(failure: mockError),
      ],
    );

    blocTest(
      'should emit SubmitUpdateMandateResponseFailureState when submitUpdateMandateReason is called and thrown exception',
      build: () {
        when(mockAchUseCase
                .submitUpdateMandateReason(mockSubmitUpdateMandateReasonReq))
            .thenThrow((_) async => Exception('some error'));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.submitUpdateMandateReason(mockSubmitUpdateMandateReasonReq);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        SrUpdateLoadingState(),
        SubmitUpdateMandateResponseFailureState(failure: NoDataFailure()),
      ],
    );
  });
  group('test updateEnach', () {
    blocTest(
      'should emit UpdateEnachStatusSuccessState',
      build: () {
        when(mockAchUseCase.updateEnach(mockUpdateEnachStatusRequest))
            .thenAnswer((_) async => Right(mockUpdateEnachStatusResponse));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.updateEnach(mockUpdateEnachStatusRequest);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        UpdateEnachStatusSuccessState(response: mockUpdateEnachStatusResponse),
      ],
    );

    blocTest(
      'should emit UpdateEnachStatusFailureState when updateEnach is called with failure',
      build: () {
        when(mockAchUseCase.updateEnach(mockUpdateEnachStatusRequest))
            .thenAnswer((_) async => Left(mockError));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.updateEnach(mockUpdateEnachStatusRequest);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        UpdateEnachStatusFailureState(failure: mockError),
      ],
    );

    blocTest(
      'should emit UpdateEnachStatusFailureState when updateEnach is called and thrown exception',
      build: () {
        when(mockAchUseCase.updateEnach(mockUpdateEnachStatusRequest))
            .thenThrow((_) async => Exception('some error'));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.updateEnach(mockUpdateEnachStatusRequest);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        UpdateEnachStatusFailureState(failure: NoDataFailure()),
      ],
    );
  });
  group('test createSRCancelMandate', () {
    blocTest(
      'should emit CreateSrCancelMandateSuccessState',
      build: () {
        when(mockAchUseCase.createSRCancelMandate(mockCreateSrCancelMandateReq))
            .thenAnswer((_) async => Right(mockCreateSrCancelMandateRes));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.createSRCancelMandate(mockCreateSrCancelMandateReq);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        SrCancelLoadingState(),
        CreateSrCancelMandateSuccessState(
            response: mockCreateSrCancelMandateRes),
      ],
    );

    blocTest(
      'should emit CreateSrCancelMandateFailureState when createSRCancelMandate is called with failure',
      build: () {
        when(mockAchUseCase.createSRCancelMandate(mockCreateSrCancelMandateReq))
            .thenAnswer((_) async => Left(mockError));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.createSRCancelMandate(mockCreateSrCancelMandateReq);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        SrCancelLoadingState(),
        CreateSrCancelMandateFailureState(failure: mockError),
      ],
    );

    blocTest(
      'should emit CreateSrCancelMandateFailureState when createSRCancelMandate is called and thrown exception',
      build: () {
        when(mockAchUseCase.createSRCancelMandate(mockCreateSrCancelMandateReq))
            .thenThrow((_) async => Exception('some error'));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.createSRCancelMandate(mockCreateSrCancelMandateReq);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        SrCancelLoadingState(),
        CreateSrCancelMandateFailureState(failure: NoDataFailure()),
      ],
    );
  });
  group('test createSRHoldMandate', () {
    blocTest(
      'should emit CreateSrCancelMandateSuccessState',
      build: () {
        when(mockAchUseCase.createSRHoldMandate(mockCreateSrHoldMandateReq))
            .thenAnswer((_) async => Right(mockCreateSrHoldMandateRes));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.createSRHoldMandate(mockCreateSrHoldMandateReq);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        SrHoldLoadingState(),
        CreateSrHoldMandateSuccessState(response: mockCreateSrHoldMandateRes),
      ],
    );

    blocTest(
      'should emit CreateSrHoldMandateFailureState when createSRHoldMandate is called with failure',
      build: () {
        when(mockAchUseCase.createSRHoldMandate(mockCreateSrHoldMandateReq))
            .thenAnswer((_) async => Left(mockError));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.createSRHoldMandate(mockCreateSrHoldMandateReq);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        SrHoldLoadingState(),
        CreateSrHoldMandateFailureState(failure: mockError),
      ],
    );

    blocTest(
      'should emit CreateSrHoldMandateFailureState when createSRHoldMandate is called and thrown exception',
      build: () {
        when(mockAchUseCase.createSRHoldMandate(mockCreateSrHoldMandateReq))
            .thenThrow((_) async => Exception('some error'));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.createSRHoldMandate(mockCreateSrHoldMandateReq);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        SrHoldLoadingState(),
        CreateSrHoldMandateFailureState(failure: NoDataFailure()),
      ],
    );
  });
  group('test reactiveMandate', () {
    blocTest(
      'should emit ReactiveMandateSuccessState',
      build: () {
        when(mockAchUseCase.reactiveMandate(mockReactiveMandateReq))
            .thenAnswer((_) async => Right(mockReactiveMandateRes));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.reactiveMandate(mockReactiveMandateReq);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        ReactiveMandateSuccessState(response: mockReactiveMandateRes),
      ],
    );

    blocTest(
      'should emit ReactiveMandateFailureState when reactiveMandate is called with failure',
      build: () {
        when(mockAchUseCase.reactiveMandate(mockReactiveMandateReq))
            .thenAnswer((_) async => Left(mockError));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.reactiveMandate(mockReactiveMandateReq);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        ReactiveMandateFailureState(failure: mockError),
      ],
    );

    blocTest(
      'should emit ReactiveMandateFailureState when reactiveMandate is called and thrown exception',
      build: () {
        when(mockAchUseCase.reactiveMandate(mockReactiveMandateReq))
            .thenThrow((_) async => Exception('some error'));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.reactiveMandate(mockReactiveMandateReq);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        ReactiveMandateFailureState(failure: NoDataFailure()),
      ],
    );
  });
  group('test getUpdateMandateReason', () {
    blocTest(
      'should emit GetUpdateMandeReasonSuccessState',
      build: () {
        when(mockAchUseCase.getUpdateMandateReason())
            .thenAnswer((_) async => Right(mockUpdateMandateReasonResp));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.getUpdateMandateReason();
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        GetUpdateMandeReasonSuccessState(response: mockUpdateMandateReasonResp),
      ],
    );

    blocTest(
      'should emit GetUpdateMandeReasonFailureState when getUpdateMandateReason is called with failure',
      build: () {
        when(mockAchUseCase.getUpdateMandateReason())
            .thenAnswer((_) async => Left(mockError));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.getUpdateMandateReason();
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        GetUpdateMandeReasonFailureState(failure: mockError),
      ],
    );

    blocTest(
      'should emit GetUpdateMandeReasonFailureState when getUpdateMandateReason is called and thrown exception',
      build: () {
        when(mockAchUseCase.getUpdateMandateReason())
            .thenThrow((_) async => Exception('some error'));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.getUpdateMandateReason();
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        GetUpdateMandeReasonFailureState(failure: NoDataFailure()),
      ],
    );
  });
  group('test validateVpa', () {
    blocTest(
      'should emit ValidateVpaSuccessState',
      build: () {
        when(mockAchUseCase.validateVpa(mockValidateVpaReq))
            .thenAnswer((_) async => Right(mockValidateVpaResp));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.validateVpa(mockValidateVpaReq);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        ValidateVpaSuccessState(response: mockValidateVpaResp),
      ],
    );

    blocTest(
      'should emit ValidateVpaFailureState when validateVpa is called with failure',
      build: () {
        when(mockAchUseCase.validateVpa(mockValidateVpaReq))
            .thenAnswer((_) async => Left(mockError));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.validateVpa(mockValidateVpaReq);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        ValidateVpaFailureState(failure: mockError),
      ],
    );

    blocTest(
      'should emit ValidateVpaFailureState when validateVpa is called and thrown exception',
      build: () {
        when(mockAchUseCase.validateVpa(mockValidateVpaReq))
            .thenThrow((_) async => Exception('some error'));
        return cubit;
      },
      act: (AchCubit cubit) {
        cubit.validateVpa(mockValidateVpaReq);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        ValidateVpaFailureState(failure: NoDataFailure()),
      ],
    );
  });
}
