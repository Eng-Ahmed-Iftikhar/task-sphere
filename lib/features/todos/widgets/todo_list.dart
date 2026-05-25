import 'package:flutter/material.dart';
import 'package:tasksphere/features/todos/todo_model.dart';
import 'package:tasksphere/features/todos/widgets/todo_tile.dart';

class TodoList extends StatefulWidget {
  final List<TodoModel> todos;
  final VoidCallback? onUpdate;

  const TodoList({super.key, required this.todos, this.onUpdate});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    final todos = widget.todos;

    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return TodoTile(todo: todo, onUpdate: widget.onUpdate);
      },
    );
  }
}
