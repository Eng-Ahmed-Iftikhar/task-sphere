import 'package:fpdart/fpdart.dart';
import 'package:tasksphere/core/error/failures.dart';
import 'package:tasksphere/features/todos/domain/entities/todo_entity.dart';
import 'package:tasksphere/features/todos/domain/repositories/todo_repository.dart';

class CreateTodoUseCase {
  final TodoRepository _repository;

  CreateTodoUseCase(this._repository);

  Future<Either<Failure, TodoEntity>> execute({
    required String title,
    required String description,
  }) {
    // Add your business logic here
    if (title.isEmpty || description.isEmpty) {
      return Future.value(
        const Left(InputFailure(message: "Title and description are required")),
      );
    }
    return _repository.create(title: title, description: description);
  }
}
