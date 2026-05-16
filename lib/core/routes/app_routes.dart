import 'package:flutter/material.dart';
import 'package:tasksphere/features/auth/login_screen.dart';
import 'package:tasksphere/features/home/home_screen.dart';

class RoutePaths {
  static final home = "/";
  static final login = "/login";
}

Map<String, Widget Function(BuildContext)> appRoutes = {
  RoutePaths.home: (context) => const HomeScreen(),
  RoutePaths.login: (context) => const LoginScreen(),
};
