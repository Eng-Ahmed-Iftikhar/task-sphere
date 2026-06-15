import 'package:tasksphere/core/constants/app_constants.dart';
import 'package:tasksphere/core/providers/router_providers.dart';
import 'package:tasksphere/core/router/routes.dart';
import 'package:tasksphere/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();

  final refreshNotifier = ref.read(goRouterRefreshProvider);
  return GoRouter(
    navigatorKey: rootNavigatorKey,

    initialLocation: AppConstants.initialRoute,
    debugLogDiagnostics: true,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authProvider);

      final isLoggedIn = authState.asData?.value.isAuthenticated ?? false;

      final isAuthStateLoading = authState.isLoading;
      final location = state.matchedLocation;
      print("location $location");
      final isAuthRoute =
          location == RoutePaths.login || location == RoutePaths.register;

      // Avoid redirecting until the auth check finishes.
      if (isAuthStateLoading) {
        return null;
      }

      if (!isLoggedIn && !isAuthRoute) {
        return RoutePaths.login;
      }

      if (isLoggedIn && isAuthRoute) {
        return RoutePaths.home;
      }

      return null;
    },
    routes: appRoutes,
  );
});
