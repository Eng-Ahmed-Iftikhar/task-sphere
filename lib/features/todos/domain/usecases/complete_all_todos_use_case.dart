import 'package:fpdart/fpdart.dart';
import 'package:tasksphere/core/error/failures.dart';
import 'package:tasksphere/features/todos/domain/repositories/todo_repository.dart';

class CompleteAllTodosUseCase {
  final TodoRepository _repository;

  CompleteAllTodosUseCase(this._repository);

  Future<Either<Failure, void>> execute() {
    return _repository.completeAllTodos();
  }
}
