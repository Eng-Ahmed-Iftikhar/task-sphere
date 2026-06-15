// Auth notifier

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasksphere/core/error/firebase_auth_failures.dart';
import 'package:tasksphere/features/auth/presentation/notifiers/auth_state.dart';
import 'package:tasksphere/features/auth/presentation/providers/auth_providers.dart';

class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    state = const AsyncLoading();

    final currentUseCase = ref.read(currentUserUseCaseProvider);
    final result = await currentUseCase.execute();

    return result.fold(
      (_) => const AuthState(isAuthenticated: false, isLoading: false),
      (auth) => AuthState(
        isAuthenticated: true,
        user: auth.user,
        accessToken: auth.accessToken,
        isLoading: false,
      ),
    );
  }

  // Check auth status
  Future<void> checkAuthStatus() async {
    final currentState = state.asData?.value ?? const AuthState();
    state = const AsyncLoading();

    final currentUseCase = ref.read(currentUserUseCaseProvider);
    final result = await currentUseCase.execute();

    state = result.fold(
      (failure) => AsyncData(
        currentState.copyWith(
          isLoading: false,
          isAuthenticated: false,
          user: null,
          authFailure: failure as FirebaseAuthFailure,
        ),
      ),
      (auth) => AsyncData(
        currentState.copyWith(
          isLoading: false,
          isAuthenticated: true,
          user: auth.user,
          accessToken: auth.accessToken,
          authFailure: null,
        ),
      ),
    );
  }

  Future<void> forgotPassword({required String email}) async {
    final currentState = state.asData?.value ?? const AuthState();
    state = const AsyncLoading();

    final forgotPassowrdUseCase = ref.read(forgotPasswordUseCaseProvider);
    final result = await forgotPassowrdUseCase.execute(email: email);

    state = result.fold(
      (failure) => AsyncData(
        currentState.copyWith(
          isLoading: false,
          isAuthenticated: false,
          user: null,
          authFailure: failure as FirebaseAuthFailure,
        ),
      ),
      (user) => AsyncData(
        currentState.copyWith(
          isLoading: false,
          isAuthenticated: false,
          user: null,
          authFailure: null,
        ),
      ),
    );
  }

  // Login
  Future<void> login({required String email, required String password}) async {
    final currentState = state.asData?.value ?? const AuthState();

    final loginUseCase = ref.read(loginUseCaseProvider);
    final result = await loginUseCase.execute(email: email, password: password);

    result.fold(
      (failure) => state = AsyncData(
        currentState.copyWith(
          isLoading: false,
          isAuthenticated: false,
          authFailure: failure as FirebaseAuthFailure,
        ),
      ),
      (auth) => state = AsyncData(
        currentState.copyWith(
          isLoading: false,
          isAuthenticated: true,
          user: auth.user,
          accessToken: auth.accessToken,
          authFailure: null,
        ),
      ),
    );
  }

  // Login
  Future<void> loginWithGoogle() async {
    final currentState = state.asData?.value ?? const AuthState();

    final loginWithGoogleUseCase = ref.read(loginWithGoogleUseCaseProvider);
    final result = await loginWithGoogleUseCase.execute();

    result.fold(
      (failure) => state = AsyncData(
        currentState.copyWith(
          isLoading: false,
          isAuthenticated: false,
          authFailure: failure as FirebaseAuthFailure,
        ),
      ),
      (auth) => state = AsyncData(
        currentState.copyWith(
          isLoading: false,
          isAuthenticated: true,
          user: auth.user,
          accessToken: auth.accessToken,
          authFailure: null,
        ),
      ),
    );
  }

  // register
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final currentState = state.asData?.value ?? const AuthState();

    final registerUseCase = ref.read(registerUseCaseProvider);

    final result = await registerUseCase.execute(
      name: name,
      email: email,
      password: password,
    );

    result.fold(
      (failure) => state = AsyncData(
        currentState.copyWith(
          isLoading: false,
          isAuthenticated: false,
          authFailure: failure as FirebaseAuthFailure,
        ),
      ),
      (auth) => state = AsyncData(
        currentState.copyWith(
          isLoading: false,
          isAuthenticated: true,
          user: auth.user,
          accessToken: auth.accessToken,
          authFailure: null,
        ),
      ),
    );
  }

  // register
  Future<void> logout() async {
    final currentState = state.asData?.value ?? const AuthState();

    final logoutUseCase = ref.read(logoutUseCaseProvider);

    final result = await logoutUseCase.execute();

    result.fold(
      (failure) => state = AsyncData(
        currentState.copyWith(
          isLoading: false,
          isAuthenticated: false,
          authFailure: failure as FirebaseAuthFailure,
        ),
      ),
      (user) => state = AsyncData(
        currentState.copyWith(
          isLoading: false,
          isAuthenticated: false,
          user: null,
          authFailure: null,
        ),
      ),
    );
  }
}
