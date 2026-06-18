import 'package:fpdart/fpdart.dart';
import 'package:tasksphere/core/error/failures.dart';
import 'package:tasksphere/features/todos/domain/repositories/todo_repository.dart';

class UpdateTodoUseCase {
  final TodoRepository _repository;

  UpdateTodoUseCase(this._repository);

  Future<Either<Failure, void>> execute({
    required String id,
    required String title,
    required String description,
  }) {
    return _repository.update(id: id, title: title, description: description);
  }
}
