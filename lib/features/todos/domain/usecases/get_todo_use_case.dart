import 'package:fpdart/fpdart.dart';
import 'package:tasksphere/core/error/failures.dart';
import 'package:tasksphere/features/todos/domain/entities/todo_entity.dart';
import 'package:tasksphere/features/todos/domain/repositories/todo_repository.dart';

class GetTodoUseCase {
  final TodoRepository _repository;

  GetTodoUseCase(this._repository);

  Future<Either<Failure, TodoEntity>> execute({required String id}) {
    // Add your business logic here
    if (id.isEmpty) {
      return Future.value(const Left(InputFailure(message: "id are required")));
    }
    return _repository.getById(id: id);
  }
}
