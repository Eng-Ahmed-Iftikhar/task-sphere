import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tasksphere/core/router/routes.dart';
import 'package:tasksphere/core/widgets/layouts/scaffold_layout.dart';
import 'package:tasksphere/features/todos/presentation/providers/todo_providers.dart';
import 'package:tasksphere/features/todos/presentation/widgets/empty_todos.dart';
import 'package:tasksphere/features/todos/presentation/widgets/todo_list.dart';

class TodosScreen extends ConsumerStatefulWidget {
  const TodosScreen({super.key});

  @override
  ConsumerState<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends ConsumerState<TodosScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  Future<void> loadTodos() async {
    final todoActions = ref.read(todoProvider.notifier);
    await todoActions.getAll();
  }

  Future<void> navigateToCreatePage() async {
    context.pushNamed(RouteNames.createTodo);
  }

  Future<void> completeAllTodos() async {
    final todoActions = ref.read(todoProvider.notifier);
    setState(() {
      _isLoading = true;
    });
    await todoActions.completeAllTodos();
    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("All todos completed successfully.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(todoProvider);

    return ScaffoldLayout(
      onRefresh: loadTodos,
      appBar: AppBar(
        title: const Text("Todos"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: navigateToCreatePage,
          ),
        ],
      ),
      body: todos.when(
        data: (todoState) {
          final todos = todoState.todos;
          print("todos $todos");
          final error = todoState.failure;
          if (error != null) {
            return Center(child: Text(error.message));
          }
          if (todos.isEmpty) {
            return const EmptyTodos();
          }
          final hasIncompleteTodos = todos.any((todo) => !todo.completed);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                if (hasIncompleteTodos) ...[
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: completeAllTodos,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _isLoading
                              ? SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : SizedBox.shrink(),
                          SizedBox(width: 10),
                          Text("Mark all completed"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                Expanded(child: TodoList(todos: todos)),
              ],
            ),
          );
        },
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
