import 'package:tasksphere/core/error/firebase_auth_failures.dart';
import 'package:tasksphere/features/auth/domain/entities/user_entity.dart';

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? provider;
  final UserEntity? user;
  final String? accessToken;

  final FirebaseAuthFailure? authFailure;

  const AuthState({
    this.isAuthenticated = false,

    this.isLoading = false,
    this.provider,
    this.accessToken,
    this.user,
    this.authFailure,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? provider,
    UserEntity? user,
    String? accessToken,
    FirebaseAuthFailure? authFailure,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      provider: provider ?? this.provider,
      accessToken: accessToken ?? this.accessToken,
      authFailure: authFailure,
    );
  }
}
