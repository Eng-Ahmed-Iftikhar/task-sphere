import 'package:fpdart/fpdart.dart';
import 'package:tasksphere/core/error/failures.dart';
import 'package:tasksphere/features/todos/domain/repositories/todo_repository.dart';

class DeleteTodoUseCase {
  final TodoRepository _repository;

  DeleteTodoUseCase(this._repository);

  Future<Either<Failure, void>> execute({required String id}) {
    // Add any validation logic here if needed
    if (id.isEmpty) {
      return Future.value(
        const Left(InputFailure(message: 'Email and password cannot be empty')),
      );
    }

    return _repository.delete(id: id);
  }
}
