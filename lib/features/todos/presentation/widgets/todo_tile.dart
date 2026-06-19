import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tasksphere/core/router/routes.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasksphere/core/constants/app_constants.dart';
import 'package:tasksphere/features/todos/data/models/todo_model.dart';
import 'package:tasksphere/features/todos/domain/entities/todo_entity.dart';
import 'package:tasksphere/features/todos/presentation/providers/todo_providers.dart';
import 'package:tasksphere/features/todos/presentation/widgets/show_delete_todo_dialog.dart';

class TodoTile extends ConsumerStatefulWidget {
  final TodoEntity todo;

  const TodoTile({super.key, required this.todo});

  @override
  ConsumerState<TodoTile> createState() => _TodoTileState();
}

class _TodoTileState extends ConsumerState<TodoTile> {
  bool isDeleting = false;
  bool isCompleting = false;

  Future<void> navigateToUpdatePage() async {
    context.pushNamed(
      RouteNames.updateTodo,
      pathParameters: {"id": widget.todo.id.toString()},
    );
  }

  Future<void> toggleTodo(bool? isCompleted) async {
    final todoActions = ref.read(todoProvider.notifier);
    setState(() {
      isCompleting = true;
    });
    await todoActions.toggleCompleted(
      id: widget.todo.id,
      completed: isCompleted ?? !widget.todo.completed,
    );
    setState(() {
      isCompleting = false;
    });
  }

  Future<void> saveTodos() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(AppConstants.todoStorageKey);
    List<TodoModel> todos = [];
    if (data != null) {
      final decoded = jsonDecode(data) as List;

      todos = decoded.map((e) => TodoModel.fromJson(e)).toList();
    }

    final encoded = jsonEncode(todos.map((e) => e.toJson()).toList());

    await prefs.setString(AppConstants.todoStorageKey, encoded);
  }

  Future<void> deleteTodo() async {
    await showDeleteTodoDialog(
      context: context,
      onConfirm: () async {
        final todoActions = ref.read(todoProvider.notifier);
        setState(() {
          isDeleting = true;
        });
        await todoActions.delete(id: widget.todo.id);
        setState(() {
          isDeleting = false;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Todo deleted successfully")),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final todo = widget.todo;
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: () => navigateToUpdatePage(),
        leading: isCompleting
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: AppConstants.secondaryColor,
                  strokeWidth: 2,
                ),
              )
            : SizedBox(
                height: 20,
                width: 20,
                child: Checkbox(
                  value: todo.completed,
                  onChanged: toggleTodo,
                  activeColor: AppConstants.secondaryColor,
                ),
              ),

        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.completed
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Text(
          todo.description,
          style: TextStyle(
            decoration: todo.completed
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: todo.completed ? Colors.grey : null,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20,
              width: 20,
              child: IconButton(
                onPressed: navigateToUpdatePage,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.edit,
                  color: AppConstants.secondaryColor,
                  size: 20,
                ),
              ),
            ),
            SizedBox(height: 20, width: 20),
            SizedBox(
              height: 20,
              width: 20,
              child: isDeleting
                  ? const CircularProgressIndicator(
                      color: Colors.red,
                      strokeWidth: 2,
                    )
                  : IconButton(
                      onPressed: deleteTodo,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
