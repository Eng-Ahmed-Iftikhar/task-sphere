// Auth notifier

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tasksphere/core/error/failures.dart';
import 'package:tasksphere/features/todos/domain/entities/todo_entity.dart';
import 'package:tasksphere/features/todos/presentation/notifiers/todo_state.dart';
import 'package:tasksphere/features/todos/presentation/providers/todo_providers.dart';

class TodoNotifier extends AsyncNotifier<TodoState> {
  @override
  Future<TodoState> build() async {
    state = const AsyncLoading();

    final currentUseCase = ref.read(getTodosUseCaseProvider);
    final result = await currentUseCase.execute();

    return result.fold(
      (failure) => TodoState(isLoading: false, todos: [], failure: failure),
      (todos) => TodoState(isLoading: false, todos: todos, failure: null),
    );
  }

  Future<void> create({
    required String title,
    required String description,
  }) async {
    final currentState =
        state.asData?.value ??
        const TodoState(isLoading: false, todos: [], failure: null);

    final useCase = ref.read(createTodoUseCaseProvider);
    final result = await useCase.execute(
      title: title,
      description: description,
    );

    state = result.fold(
      (failure) => AsyncData(
        currentState.copyWith(
          isLoading: false,
          failure: failure,
          todos: currentState.todos,
        ),
      ),
      (todo) => AsyncData(
        currentState.copyWith(
          isLoading: false,
          failure: null,
          todos: currentState.todos + [todo],
        ),
      ),
    );
  }

  Future<void> updateOne({
    required String id,
    required String title,
    required String description,
  }) async {
    final currentState =
        state.asData?.value ??
        const TodoState(isLoading: false, todos: [], failure: null);

    final useCase = ref.read(updateTodoUseCaseProvider);
    final result = await useCase.execute(
      id: id,
      title: title,
      description: description,
    );

    state = result.fold(
      (failure) => AsyncData(
        currentState.copyWith(
          isLoading: false,
          failure: failure,
          todos: currentState.todos,
        ),
      ),
      (_) => AsyncData(
        currentState.copyWith(
          isLoading: false,
          failure: null,
          todos: currentState.todos.map((todo) {
            if (todo.id == id) {
              return todo.copyWith(title: title, description: description);
            }
            return todo;
          }).toList(),
        ),
      ),
    );
  }

  Future<void> toggleCompleted({
    required String id,
    required bool completed,
  }) async {
    final currentState =
        state.asData?.value ??
        const TodoState(isLoading: false, todos: [], failure: null);

    final useCase = ref.read(toggleTodoUseCaseProvider);
    final result = await useCase.execute(id: id, completed: completed);

    state = result.fold(
      (failure) => AsyncData(
        currentState.copyWith(
          isLoading: false,
          failure: failure,
          todos: currentState.todos,
        ),
      ),
      (_) => AsyncData(
        currentState.copyWith(
          isLoading: false,
          failure: null,
          todos: currentState.todos.map((todo) {
            if (todo.id == id) {
              return todo.copyWith(completed: completed);
            }
            return todo;
          }).toList(),
        ),
      ),
    );
  }

  // Login
  Future<void> delete({required String id}) async {
    final currentState =
        state.asData?.value ??
        const TodoState(isLoading: false, todos: [], failure: null);

    final useCase = ref.read(deleteTodoUseCaseProvider);
    final result = await useCase.execute(id: id);

    result.fold(
      (failure) => state = AsyncData(
        currentState.copyWith(
          isLoading: false,
          failure: failure,
          todos: currentState.todos,
        ),
      ),
      (_) => state = AsyncData(
        currentState.copyWith(
          isLoading: false,
          failure: null,
          todos: currentState.todos.where((todo) => todo.id != id).toList(),
        ),
      ),
    );
  }

  Future<Either<Failure, TodoEntity>> getById({required String id}) async {
    final useCase = ref.read(getTodoUseCaseProvider);
    final result = await useCase.execute(id: id);
    return result;
  }

  // getAll
  Future<void> getAll() async {
    final currentState =
        state.asData?.value ??
        const TodoState(isLoading: false, todos: [], failure: null);

    final useCase = ref.read(getTodosUseCaseProvider);
    final result = await useCase.execute();

    result.fold(
      (failure) => state = AsyncData(
        currentState.copyWith(
          isLoading: false,
          failure: failure,
          todos: currentState.todos,
        ),
      ),
      (todos) => state = AsyncData(
        currentState.copyWith(isLoading: false, failure: null, todos: todos),
      ),
    );
  }
}
