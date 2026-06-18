import 'package:fpdart/fpdart.dart';
import 'package:tasksphere/core/error/failures.dart';
import 'package:tasksphere/features/todos/domain/entities/todo_entity.dart';
import 'package:tasksphere/features/todos/domain/repositories/todo_repository.dart';

class GetTodosUseCase {
  final TodoRepository _repository;

  GetTodosUseCase(this._repository);

  Future<Either<Failure, List<TodoEntity>>> execute() {
    return _repository.getAll();
  }
}
