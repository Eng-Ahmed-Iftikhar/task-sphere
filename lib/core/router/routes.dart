import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasksphere/features/auth/presentation/screens/login_screen.dart';
import 'package:tasksphere/features/auth/presentation/screens/register_screen.dart';
import 'package:tasksphere/features/counter/counter_screen.dart';
import 'package:tasksphere/features/home/screens/home_screen.dart';
import 'package:tasksphere/features/home/shells/home_shell.dart';
import 'package:tasksphere/features/todos/create_todo_screen.dart';
import 'package:tasksphere/features/todos/todos_screen.dart';
import 'package:tasksphere/features/todos/update_todo_screen.dart';

class RoutePaths {
  static const String home = "/";
  static const String login = "/login";
  static const String register = "/register";
  static const String counter = "/counter";
  static const String todos = "/todos";
  static const String createTodo = "/create-todo";
  static const String updateTodo = "/update-todo/:id";
}

class RouteNames {
  static const String home = "home_route";
  static const String register = "register_route";
  static const String login = "login_route";
  static const String counter = "counter_route";
  static const String todos = "todos_route";
  static const String createTodo = "create_todo_route";
  static const String updateTodo = "update_todo_route";
}

final shellNavigatorKey = GlobalKey<NavigatorState>();

final List<RouteBase> appRoutes = [
  ShellRoute(
    navigatorKey: shellNavigatorKey,
    builder: (context, state, child) {
      return HomeShell(child: child);
    },
    routes: [
      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RoutePaths.counter,
        name: RouteNames.counter,
        builder: (context, state) => const CounterScreen(),
      ),
      GoRoute(
        path: RoutePaths.todos,
        name: RouteNames.todos,
        builder: (context, state) => const TodosScreen(),
      ),
      GoRoute(
        path: RoutePaths.createTodo,
        name: RouteNames.createTodo,
        builder: (context, state) => const CreateTodoScreen(),
      ),
      GoRoute(
        path: RoutePaths.updateTodo,
        name: RouteNames.updateTodo,
        builder: (context, state) {
          final id = state.uri.queryParameters['id'] ?? '';
          return UpdateTodoScreen(id: id);
        },
      ),
    ],
  ),

  // AUTH ROUTES
  GoRoute(
    path: RoutePaths.register,
    name: RouteNames.register,
    builder: (context, state) => const RegisterScreen(),
  ),

  GoRoute(
    path: RoutePaths.login,
    name: RouteNames.login,
    builder: (context, state) {
      return LoginScreen();
    },
  ),
];
