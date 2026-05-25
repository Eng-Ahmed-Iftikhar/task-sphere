import 'package:flutter/material.dart';
import 'package:tasksphere/features/auth/login_screen.dart';
import 'package:tasksphere/features/counter/counter_screen.dart';
import 'package:tasksphere/features/home/home_screen.dart';

class RoutePaths {
  static final home = "/";
  static final login = "/login";
  static final counter = "/counter";
  static final todo = "/todo";
}

Map<String, Widget Function(BuildContext)> appRoutes = {
  RoutePaths.home: (context) => const HomeScreen(),
  RoutePaths.login: (context) => const LoginScreen(),
  RoutePaths.counter: (context) => const CounterScreen(),
  RoutePaths.todo: (context) => const HomeScreen(),
};
