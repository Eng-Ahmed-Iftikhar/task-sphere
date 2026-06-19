import 'package:fpdart/fpdart.dart';
import 'package:tasksphere/core/error/failures.dart';
import 'package:tasksphere/features/todos/domain/entities/todo_entity.dart';

abstract class TodoRepository {
  /// Login a user with email and password
  Future<Either<Failure, TodoEntity>> create({
    required String title,
    required String description,
  });
  Future<Either<Failure, void>> update({
    required String id,
    required String title,
    required String description,
  });
  Future<Either<Failure, void>> delete({required String id});
  Future<Either<Failure, void>> toggleCompleted({
    required String id,
    required bool completed,
  });

  Future<Either<Failure, void>> completeAllTodos();
  Future<Either<Failure, List<TodoEntity>>> getAll();
  Future<Either<Failure, TodoEntity>> getById({required String id});
}
