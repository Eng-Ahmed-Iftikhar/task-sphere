import 'package:tasksphere/core/error/failures.dart';
import 'package:tasksphere/features/todos/domain/entities/todo_entity.dart';

class TodoState {
  final bool isLoading;
  final List<TodoEntity> todos;
  final Failure? failure;

  const TodoState({
    required this.isLoading,
    required this.todos,
    required this.failure,
  });

  TodoState copyWith({
    bool? isLoading,
    List<TodoEntity>? todos,
    Failure? failure,
  }) {
    return TodoState(
      isLoading: isLoading ?? this.isLoading,
      todos: todos ?? this.todos,
      failure: failure ?? this.failure,
    );
  }
}
