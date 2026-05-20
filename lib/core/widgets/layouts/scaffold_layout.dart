import 'package:flutter/material.dart';

class ScaffoldLayout extends StatelessWidget {
  final RefreshCallback? onRefresh;
  final Widget body;
  final Widget? bottomSheet;

  const ScaffoldLayout({
    super.key,
    this.onRefresh,
    required this.body,
    this.bottomSheet,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(20),
          child: RefreshIndicator(
            onRefresh: onRefresh ?? () async {},
            child: body,
          ),
        ),
      ),
      bottomSheet: bottomSheet,
    );
  }
}
