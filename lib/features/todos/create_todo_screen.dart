import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasksphere/core/constants/app_constants.dart';
import 'package:tasksphere/core/widgets/layouts/scaffold_layout.dart';
import 'package:tasksphere/features/todos/todo_model.dart';

class CreateTodoScreen extends StatefulWidget {
  final TodoModel? todo;

  const CreateTodoScreen({super.key, this.todo});

  @override
  State<CreateTodoScreen> createState() => _CreateTodoScreenState();
}

class _CreateTodoScreenState extends State<CreateTodoScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.todo != null) {
      titleController.text = widget.todo!.title;
      descriptionController.text = widget.todo!.description;
    }
  }

  void saveTodo() async {
    if (titleController.text.trim().isEmpty) return;

    final todo = TodoModel(
      id: widget.todo?.id ?? DateTime.now().millisecondsSinceEpoch,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      completed: widget.todo?.completed ?? false,
    );
    //create

    final prefs = await SharedPreferences.getInstance();
    final todosString = prefs.getString(AppConstants.todoStorageKey);
    List<TodoModel> todos = [];

    if (todosString != null) {
      final List decoded = jsonDecode(todosString);
      todos = decoded.map((e) => TodoModel.fromJson(e)).toList();
    }

    todos.add(todo);
    final newTodosString = jsonEncode(todos.map((e) => e.toJson()).toList());

    await prefs.setString(AppConstants.todoStorageKey, newTodosString);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldLayout(
      appBar: AppBar(title: Text("Create Todo")),
      body: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: "Title",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: descriptionController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: "Description",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: saveTodo, child: Text("Create")),
          ),
        ],
      ),
    );
  }
}
