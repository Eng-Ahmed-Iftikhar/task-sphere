import 'package:fpdart/fpdart.dart';
import 'package:tasksphere/core/error/failures.dart';
import 'package:tasksphere/features/auth/domain/repositories/auth_repository.dart';

class ReAuthUseCase {
  final AuthRepository _repository;

  ReAuthUseCase(this._repository);

  Future<Either<Failure, void>> execute({required String password}) {
    // Add any validation logic here if needed
    if (password.isEmpty) {
      return Future.value(
        const Left(InputFailure(message: 'Email and password cannot be empty')),
      );
    }

    return _repository.reAuthenticate(password: password);
  }
}
