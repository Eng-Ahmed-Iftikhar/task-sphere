// --- Use Cases ---
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasksphere/features/todos/data/repositories/todo_repository_impl.dart';
import 'package:tasksphere/features/todos/domain/usecases/create_todo_use_case.dart';
import 'package:tasksphere/features/todos/domain/usecases/delete_todo_use_case.dart';
import 'package:tasksphere/features/todos/domain/usecases/get_todo_use_case.dart';
import 'package:tasksphere/features/todos/domain/usecases/get_todos_use_case.dart';
import 'package:tasksphere/features/todos/domain/usecases/toggle_todo_use_case.dart';
import 'package:tasksphere/features/todos/domain/usecases/update_todo_use_case.dart';
import 'package:tasksphere/features/todos/presentation/notifiers/todo_notifier.dart';
import 'package:tasksphere/features/todos/presentation/notifiers/todo_state.dart';

final createTodoUseCaseProvider = Provider<CreateTodoUseCase>((ref) {
  return CreateTodoUseCase(ref.watch(todoRepositoryProvider));
});

final updateTodoUseCaseProvider = Provider<UpdateTodoUseCase>((ref) {
  return UpdateTodoUseCase(ref.watch(todoRepositoryProvider));
});

final deleteTodoUseCaseProvider = Provider<DeleteTodoUseCase>((ref) {
  return DeleteTodoUseCase(ref.watch(todoRepositoryProvider));
});

final getTodosUseCaseProvider = Provider<GetTodosUseCase>((ref) {
  return GetTodosUseCase(ref.watch(todoRepositoryProvider));
});

final getTodoUseCaseProvider = Provider<GetTodoUseCase>((ref) {
  return GetTodoUseCase(ref.watch(todoRepositoryProvider));
});

final toggleTodoUseCaseProvider = Provider<ToggleTodoUseCase>((ref) {
  return ToggleTodoUseCase(ref.watch(todoRepositoryProvider));
});

final todoProvider = AsyncNotifierProvider<TodoNotifier, TodoState>(
  TodoNotifier.new,
);
