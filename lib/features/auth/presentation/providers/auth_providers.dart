// --- Use Cases ---
import 'package:tasksphere/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:tasksphere/features/auth/domain/usecases/forgot_password_use_case.dart';
import 'package:tasksphere/features/auth/domain/usecases/login_use_case.dart';
import 'package:tasksphere/features/auth/domain/usecases/current_user_use_case.dart';
import 'package:tasksphere/features/auth/domain/usecases/login_with_google_use_case.dart';
import 'package:tasksphere/features/auth/domain/usecases/logout_use_case.dart';
import 'package:tasksphere/features/auth/domain/usecases/register_use_case.dart';
import 'package:tasksphere/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasksphere/features/auth/presentation/notifiers/auth_state.dart';

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final loginWithGoogleUseCaseProvider = Provider<LoginWithGoogleUseCase>((ref) {
  return LoginWithGoogleUseCase(ref.watch(authRepositoryProvider));
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(ref.watch(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
});

final currentUserUseCaseProvider = Provider<CurrentUserUseCase>((ref) {
  return CurrentUserUseCase(ref.watch(authRepositoryProvider));
});

final forgotPasswordUseCaseProvider = Provider<ForgotPasswordUseCase>((ref) {
  return ForgotPasswordUseCase(ref.watch(authRepositoryProvider));
});

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
