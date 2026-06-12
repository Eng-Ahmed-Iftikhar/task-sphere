import 'package:tasksphere/core/error/failures.dart';
import 'package:tasksphere/features/auth/domain/entities/auth_entity.dart';
import 'package:tasksphere/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<Either<Failure, AuthEntity>> execute({
    required String email,
    required String password,
    required String name,
  }) {
    // Add any validation logic here if needed
    if (email.isEmpty || password.isEmpty) {
      return Future.value(
        const Left(InputFailure(message: 'Email and password cannot be empty')),
      );
    }

    return _repository.register(name: name, email: email, password: password);
  }
}
