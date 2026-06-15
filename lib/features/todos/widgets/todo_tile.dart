import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasksphere/core/router/routes.dart';
import 'package:tasksphere/features/todos/todo_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasksphere/core/constants/app_constants.dart';
import 'package:tasksphere/features/todos/widgets/show_delete_todo_dialog.dart';

class TodoTile extends StatefulWidget {
  final TodoModel todo;
  final VoidCallback? onUpdate;

  const TodoTile({super.key, required this.todo, this.onUpdate});

  @override
  State<TodoTile> createState() => _TodoTileState();
}

class _TodoTileState extends State<TodoTile> {
  Future<void> navigateToUpdatePage(int id) async {
    context.pushNamed(
      RouteNames.updateTodo,
      pathParameters: {"id": id.toString()},
    );

    widget.onUpdate?.call();
  }

  Future<void> toggleTodo(TodoModel todo) async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(AppConstants.todoStorageKey);
    List<TodoModel> todos = [];
    if (data != null) {
      final decoded = jsonDecode(data) as List;

      todos = decoded.map((e) => TodoModel.fromJson(e)).toList();
    }
    final index = todos.indexWhere((e) => e.id == todo.id);

    todos[index] = todo.copyWith(completed: !todo.completed);
    await prefs.setString(
      AppConstants.todoStorageKey,
      jsonEncode(todos.map((e) => e.toJson()).toList()),
    );
    widget.onUpdate?.call();
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

  Future<void> deleteTodo(int id) async {
    await showDeleteTodoDialog(
      context: context,
      onConfirm: () async {
        final prefs = await SharedPreferences.getInstance();
        final data = prefs.getString(AppConstants.todoStorageKey);
        List<TodoModel> todos = [];
        if (data != null) {
          final decoded = jsonDecode(data) as List;

          todos = decoded.map((e) => TodoModel.fromJson(e)).toList();
        }
        todos.removeWhere((todo) => todo.id == id);

        await prefs.setString(
          AppConstants.todoStorageKey,
          jsonEncode(todos.map((e) => e.toJson()).toList()),
        );

        widget.onUpdate?.call();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final todo = widget.todo;
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: () => navigateToUpdatePage(todo.id),
        leading: Checkbox(
          value: todo.completed,
          activeColor: AppConstants.secondaryColor,
          onChanged: (_) {
            toggleTodo(todo);
          },
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
            IconButton(
              onPressed: () {
                navigateToUpdatePage(todo.id);
              },
              icon: Icon(Icons.edit, color: AppConstants.secondaryColor),
            ),
            IconButton(
              onPressed: () {
                deleteTodo(todo.id);
              },
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
