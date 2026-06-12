import 'package:tasksphere/core/error/failures.dart';
import 'package:tasksphere/features/auth/domain/entities/auth_entity.dart';
import 'package:tasksphere/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class LoginWithGoogleUseCase {
  final AuthRepository _repository;

  LoginWithGoogleUseCase(this._repository);

  Future<Either<Failure, AuthEntity>> execute() {
    return _repository.loginWithGoogle();
  }
}
