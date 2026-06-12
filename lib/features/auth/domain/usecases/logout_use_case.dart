import 'package:tasksphere/core/error/failures.dart';
import 'package:tasksphere/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  Future<Either<Failure, void>> execute() {
    return _repository.logout();
  }
}
