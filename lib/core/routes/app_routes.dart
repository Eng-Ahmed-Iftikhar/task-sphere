import 'package:flutter/material.dart';
import 'package:tasksphere/features/auth/login_screen.dart';
import 'package:tasksphere/features/counter/counter_screen.dart';
import 'package:tasksphere/features/home/home_screen.dart';
import 'package:tasksphere/features/todos/create_todo_screen.dart';
import 'package:tasksphere/features/todos/todos_screen.dart';
import 'package:tasksphere/features/todos/update_todo_screen.dart';

class RoutePaths {
  static const home = "/";
  static const login = "/login";
  static const counter = "/counter";
  static const todos = "/todos";
  static const createTodo = "/create-todo";
  static const updateTodo = "/update-todo";
}

Map<String, WidgetBuilder> appRoutes = {
  RoutePaths.home: (context) => const HomeScreen(),
  RoutePaths.login: (context) => const LoginScreen(),
  RoutePaths.counter: (context) => const CounterScreen(),
  RoutePaths.todos: (context) => const TodosScreen(),
  RoutePaths.createTodo: (context) => const CreateTodoScreen(),

  RoutePaths.updateTodo: (context) {
    final route = ModalRoute.of(context);

    final args = route?.settings.arguments;

    // Safe fallback to avoid crash
    final id = args?.toString() ?? "";

    return UpdateTodoScreen(id: id);
  },
};
