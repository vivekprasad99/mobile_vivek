import 'package:common/features/home/data/models/logout_response.dart';
import 'package:common/features/home/data/models/update_theme_request.dart';
import 'package:common/features/home/data/models/update_theme_response.dart';
import 'package:common/features/home/domain/repositories/home_repository.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class UpdateThemeUseCase
    extends UseCase<UpdateThemeResponse, UpdateThemeRequest> {
  final HomeRepository repository;

  UpdateThemeUseCase({required this.repository});

  @override
  Future<Either<Failure, UpdateThemeResponse>> call(
      UpdateThemeRequest params,) async {
    return await repository.updateUserTheme(params);
  }

  Future<Either<Failure, LogoutResponse>> logout(String token) async {
    return await repository.logout(token);
  }
}
