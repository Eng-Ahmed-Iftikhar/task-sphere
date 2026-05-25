import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasksphere/core/constants/app_constants.dart';
import 'package:tasksphere/core/routes/app_routes.dart';
import 'package:tasksphere/core/widgets/layouts/scaffold_layout.dart';
import 'package:tasksphere/features/todos/todo_model.dart';
import 'package:tasksphere/features/todos/widgets/EmptyTodos.dart';
import 'package:tasksphere/features/todos/widgets/todo_list.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key});

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> with RouteAware {
  List<TodoModel> todos = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppConstants.routeObserver.subscribe(
      this,
      ModalRoute.of(context)! as PageRoute,
    );
  }

  @override
  void dispose() {
    AppConstants.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    loadTodos();
  }

  Future<void> loadTodos() async {
    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(AppConstants.todoStorageKey);

    if (data != null) {
      final decoded = jsonDecode(data) as List;

      todos = decoded.map((e) => TodoModel.fromJson(e)).toList();
    } else {
      todos = [];
    }

    setState(() => isLoading = false);
  }

  Future<void> navigateToCreatePage() async {
    await Navigator.pushNamed(context, RoutePaths.createTodo);
  }

  @override
  Widget build(BuildContext context) {
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : todos.isEmpty
          ? const EmptyTodos()
          : TodoList(todos: todos, onUpdate: loadTodos),
    );
  }
}
