import 'package:auth/features/login_and_registration/data/models/get_theme_request.dart';
import 'package:auth/features/login_and_registration/data/models/get_theme_response.dart';
import 'package:auth/features/login_and_registration/domain/repositories/auth_repository.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class GetThemeUseCase extends UseCase<GetThemeResponse, GetThemeRequest> {
  final AuthRepository repository;

  GetThemeUseCase({required this.repository});

  @override
  Future<Either<Failure, GetThemeResponse>> call(GetThemeRequest params) async {
    return await repository.getUserTheme(params);
  }
}
