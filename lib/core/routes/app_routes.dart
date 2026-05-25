import 'package:flutter/material.dart';
import 'package:tasksphere/features/auth/login_screen.dart';
import 'package:tasksphere/features/counter/counter_screen.dart';
import 'package:tasksphere/features/home/home_screen.dart';
import 'package:tasksphere/features/todos/create_todo_screen.dart';
import 'package:tasksphere/features/todos/todos_screen.dart';
import 'package:tasksphere/features/todos/update_todo_screen.dart';

class RoutePaths {
  static final home = "/";
  static final login = "/login";
  static final counter = "/counter";
  static final todos = "/todos";
  static final createTodo = "/create-todo";
  static final updateTodo = "/update-todo";
}

Map<String, Widget Function(BuildContext)> appRoutes = {
  RoutePaths.home: (context) => const HomeScreen(),
  RoutePaths.login: (context) => const LoginScreen(),
  RoutePaths.counter: (context) => const CounterScreen(),
  RoutePaths.todos: (context) => const TodosScreen(),
  RoutePaths.createTodo: (context) => const CreateTodoScreen(),

  RoutePaths.updateTodo: (context) {
    final args = ModalRoute.of(context)!.settings.arguments;

    return UpdateTodoScreen(id: args.toString());
  },
};
