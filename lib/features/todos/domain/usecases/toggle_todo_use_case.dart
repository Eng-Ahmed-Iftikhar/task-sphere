import 'package:fpdart/fpdart.dart';
import 'package:tasksphere/core/error/failures.dart';
import 'package:tasksphere/features/todos/domain/repositories/todo_repository.dart';

class ToggleTodoUseCase {
  final TodoRepository _repository;

  ToggleTodoUseCase(this._repository);

  Future<Either<Failure, void>> execute({
    required String id,
    required bool completed,
  }) {
    return _repository.toggleCompleted(id: id, completed: completed);
  }
}
