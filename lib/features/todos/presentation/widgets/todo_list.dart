import 'package:flutter/material.dart';
import 'package:tasksphere/features/todos/domain/entities/todo_entity.dart';
import 'package:tasksphere/features/todos/presentation/widgets/todo_tile.dart';

class TodoList extends StatefulWidget {
  final List<TodoEntity> todos;

  const TodoList({super.key, required this.todos});

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
        return TodoTile(todo: todo);
      },
    );
  }
}
