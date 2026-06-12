import 'package:tasksphere/core/error/failures.dart';
import 'package:tasksphere/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class ForgotPasswordUseCase {
  final AuthRepository _repository;

  ForgotPasswordUseCase(this._repository);

  Future<Either<Failure, void>> execute({required String email}) {
    return _repository.forgotPassword(email: email);
  }
}
