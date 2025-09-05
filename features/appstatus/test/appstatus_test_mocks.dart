import 'package:appstatus/feature/data/models/application_status_request.dart' as i10;
import 'package:appstatus/feature/data/models/application_status_response.dart' as i9;
import 'package:appstatus/feature/domain/usecases/application_status_usecase.dart' as i4;
import 'package:core/config/error/failure.dart' as i6;
import 'dart:async' as i5;
import 'package:dartz/dartz.dart' as i3;
import 'package:mockito/mockito.dart' as i1;

class MockApplicationStatusUseCase extends i1.Mock
    implements i4.ApplicationStatusUseCase {
  MockApplicationStatusUseCase() {
    i1.throwOnMissingStub(this);
  }

  i5.Future<i3.Either<i6.Failure, i9.ApplicationStatusResponse>> getApplicationStatus(
          i10.ApplicationStatusRequest? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #createMPin,
          [params],
        ),
        returnValue:
            i5.Future<i3.Either<i6.Failure, i9.ApplicationStatusResponse>>.value(
                _FakeEither_1<i6.Failure, i9.ApplicationStatusResponse>(
          this,
          Invocation.method(
            #createMPin,
            [params],
          ),
        )),
      ) as i5.Future<i3.Either<i6.Failure, i9.ApplicationStatusResponse>>);
}
class _FakeEither_1<L, R> extends i1.SmartFake implements i3.Either<L, R> {
  _FakeEither_1(
    super.parent,
    super.parentInvocation,
  );
}