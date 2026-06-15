import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasksphere/core/widgets/layouts/scaffold_layout.dart';

class HomeShell extends ConsumerStatefulWidget {
  final Widget child;

  const HomeShell({super.key, required this.child});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldLayout(body: widget.child);
  }
}
