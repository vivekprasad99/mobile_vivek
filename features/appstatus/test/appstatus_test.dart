import 'package:appstatus/feature/data/models/application_status_request.dart';
import 'package:appstatus/feature/data/models/application_status_response.dart';
import 'package:appstatus/feature/domain/usecases/application_status_usecase.dart';
import 'package:appstatus/feature/presentation/cubit/application_status_cubit.dart';
import 'package:appstatus/feature/presentation/cubit/application_status_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'appstatus_test.mocks.dart';

@GenerateMocks([ApplicationStatusUseCase])
void main() async {
  // List<Data> resultdata = [Data(
  //       applicantName: "Avinash Barola",
  //       applicationDate: "2023-12-08 05:44:50",
  //       applicationNumber: "300006828",
  //       applicationStatus: "Initiated",
  //       assetName: "MAHINDRA & MAHINDRA LTD - null",
  //       branchName: "",
  //       businessExecutiveContactNumber: "",
  //       businessExecutiveName: "",
  //       subStatus: "",
  //       stage: "QDE",
  //       loanType: "Sale Purchase",
  //       lmsType: "sfdc-loan-status"
  // )];
  late ApplicationStatusCubit cubit;
  var mockApplicationStatusUseCase = MockApplicationStatusUseCase();
  var mockApplicationStatusRequest = ApplicationStatusRequest(mobileNumber:  "09768262997");
  var mockApplicationStatusResponse = ApplicationStatusResponse.fromJson(
     { "code": "SUCCESS",
      "message":
          "Unable to authenticate you through Loan Account number. Please enter your PAN card number to continue.",
      "data": [{ "applicantName": "Avinash Barola",
        "applicationDate": "2023-12-08 05:44:50",
        "applicationNumber": "300006828",
        "applicationStatus": "Initiated",
        "assetName": "MAHINDRA & MAHINDRA LTD - null",
        "branchName": "",
        "businessExecutiveContactNumber": "",
        "businessExecutiveName": "",
        "subStatus": "",
        "stage": "QDE",
        "loanType": "Sale Purchase",
        "lmsType": "sfdc-loan-status"}]} );
  var mockApplicationStatusAuthenticationRequest =
      ApplicationStatusRequest(mobileNumber: "09768262997");
  var mockApplicationStatusAuthenticationResponse = ApplicationStatusResponse.fromJson(
     { "code": "SUCCESS",
      "message":
          "Unable to authenticate you through Loan Account number. Please enter your PAN card number to continue.",
      "data": [{ "applicantName": "Avinash Barola",
        "applicationDate": "2023-12-08 05:44:50",
        "applicationNumber": "300006828",
        "applicationStatus": "Initiated",
        "assetName": "MAHINDRA & MAHINDRA LTD - null",
        "branchName": "",
        "businessExecutiveContactNumber": "",
        "businessExecutiveName": "",
        "subStatus": "",
        "stage": "QDE",
        "loanType": "Sale Purchase",
        "lmsType": "sfdc-loan-status"}]} );

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    cubit = ApplicationStatusCubit(
        applicationStatusUseCase: mockApplicationStatusUseCase);
  });

  group('test validate ApplicationStatus', () {
    blocTest(
      'should emit ApplicationStatusSuccessState, when authenticate ApplicationStatus/services is called',
      build: () {
        when(mockApplicationStatusUseCase.call(mockApplicationStatusRequest))
            .thenAnswer((_) async => Right(mockApplicationStatusResponse));
        return cubit;
      },
      act: (ApplicationStatusCubit cubit) async{
      await  cubit.getApplicationStatus(
            applicationStatusRequest:
                mockApplicationStatusAuthenticationRequest);
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        LoadingState(isLoading: true),
        ApplicationStatusSuccessState(
            response: mockApplicationStatusAuthenticationResponse),
      ],
    );
  });
}
