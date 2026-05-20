import 'package:flutter/material.dart';
import 'package:tasksphere/core/routes/app_routes.dart';
import 'package:tasksphere/core/themes/app_themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeMode = Theme.brightnessOf(context);
    final isDarkMode = themeMode == Brightness.dark;

    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: darkTheme,
      theme: lightTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      routes: appRoutes,
      initialRoute: RoutePaths.login,
    );
  }
}
