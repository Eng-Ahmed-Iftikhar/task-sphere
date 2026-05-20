import 'package:flutter/material.dart';
import 'package:tasksphere/core/widgets/Layouts/Scaffold_layout.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const ScaffoldLayout(body: Text("Home"));
  }
}
