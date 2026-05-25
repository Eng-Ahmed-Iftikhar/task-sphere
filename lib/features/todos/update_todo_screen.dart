import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasksphere/core/constants/app_constants.dart';
import 'package:tasksphere/features/todos/todo_model.dart';

class UpdateTodoScreen extends StatefulWidget {
  final String id;

  const UpdateTodoScreen({super.key, required this.id});

  @override
  State<UpdateTodoScreen> createState() => _UpdateTodoScreenState();
}

class _UpdateTodoScreenState extends State<UpdateTodoScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  TodoModel? todo;
  List<TodoModel> todos = [];

  @override
  void initState() {
    super.initState();
    getTodo();
  }

  Future<void> getTodo() async {
    final prefs = await SharedPreferences.getInstance();

    final todosString = prefs.getString(AppConstants.todoStorageKey);

    if (todosString == null) return;

    final List decoded = jsonDecode(todosString);

    todos = decoded.map((e) => TodoModel.fromJson(e)).toList();

    final selectedTodo = todos.firstWhere((e) => e.id.toString() == widget.id);

    setState(() {
      todo = selectedTodo;

      titleController.text = todo?.title ?? "";
      descriptionController.text = todo?.description ?? "";
    });
  }

  Future<void> updateTodo() async {
    final prefs = await SharedPreferences.getInstance();

    final index = todos.indexWhere((e) => e.id.toString() == widget.id);

    if (index == -1) return;

    final updatedTodo = TodoModel(
      id: todo!.id,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      completed: todo!.completed,
    );

    todos[index] = updatedTodo;

    await prefs.setString(
      AppConstants.todoStorageKey,
      jsonEncode(todos.map((e) => e.toJson()).toList()),
    );

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (todo == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Update Todo")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
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
              child: ElevatedButton(
                onPressed: updateTodo,
                child: const Text("Update Todo"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
