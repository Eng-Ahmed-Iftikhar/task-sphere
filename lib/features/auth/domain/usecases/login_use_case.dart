import 'package:tasksphere/core/error/failures.dart';
import 'package:tasksphere/features/auth/domain/entities/auth_entity.dart';
import 'package:tasksphere/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Either<Failure, AuthEntity>> execute({
    required String email,
    required String password,
  }) {
    // Add any validation logic here if needed
    if (email.isEmpty || password.isEmpty) {
      return Future.value(
        const Left(InputFailure(message: 'Email and password cannot be empty')),
      );
    }

    return _repository.login(email: email, password: password);
  }
}
