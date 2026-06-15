import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasksphere/core/constants/app_constants.dart';
import 'package:tasksphere/core/router/routes.dart';
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
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      AppConstants.routeObserver.subscribe(this, route);
    }
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
    context.pushNamed(RouteNames.createTodo);
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
