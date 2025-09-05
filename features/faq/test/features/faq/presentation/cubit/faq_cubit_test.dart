import 'package:bloc_test/bloc_test.dart';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:faq/features/data/models/faq_request.dart';
import 'package:faq/features/data/models/faq_response.dart';
import 'package:faq/features/presentation/cubit/faq_cubit.dart';
import 'package:faq/features/presentation/cubit/faq_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:faq/features/domain/usecases/faq_usecases.dart';
import 'faq_cubit_test.mocks.dart';

@GenerateMocks([FAQUseCase])
void main() async {
  late FAQCubit cubit;
  var mockFAQUseCase = MockFAQUseCase();
  var mockError = const ServerFailure('some error');

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    cubit = FAQCubit(faqUseCase: mockFAQUseCase);
  });

  var mockFAQRequest = FAQRequest(category: 'faq', language: 'en');

  var mockGetFAQResponse = FAQResponse(categories: [
    Categories(title: "", generalTypes: [
      GeneralTypes(id: "", header: "")
    ], productTypes: [
      ProductTypes(bankId: "1", title: "", subTypes: [])
    ], videoTypes: [
      VideoTypes(id: "1", header: "", videos: [Videos()])
    ])
  ]);

  group('Test FAQ API', () {
    blocTest('should emit FAQSuccessState when FAQ API is called',
        build: () {
          when(mockFAQUseCase.call(mockFAQRequest))
              .thenAnswer((_) async => Right(mockGetFAQResponse));
          return cubit;
        },
        act: (FAQCubit cubit) {
          cubit.getFAQ(request: mockFAQRequest);
        },
        wait: const Duration(seconds: 3),
        expect: () => [
              LoadingState(isLoading: true),
              LoadingState(isLoading: false),
              FAQSuccessState(response: mockGetFAQResponse)
            ]);

    blocTest('should emit FAQFailureState when FAQ API is called',
        build: () {
          when(mockFAQUseCase.call(mockFAQRequest))
              .thenAnswer((_) async => Left(mockError));
          return cubit;
        },
        act: (FAQCubit cubit) {
          cubit.getFAQ(request: mockFAQRequest);
        },
        wait: const Duration(seconds: 3),
        expect: () => [
              LoadingState(isLoading: true),
              LoadingState(isLoading: false),
              FAQFailureState(error: mockError)
            ]);
  });
}
