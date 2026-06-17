import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tasksphere/core/router/routes.dart';
import 'package:tasksphere/features/auth/presentation/providers/auth_providers.dart';

class AuthGuard extends ConsumerWidget {
  final Widget child;
  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isAuthenticated = authState.asData?.value.isAuthenticated ?? false;

    if (isAuthenticated) {
      return child;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.pushNamed(RouteNames.login);
    });

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
