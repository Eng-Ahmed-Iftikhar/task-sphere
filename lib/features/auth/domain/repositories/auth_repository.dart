import 'package:image_picker/image_picker.dart';
import 'package:tasksphere/core/error/failures.dart';
import 'package:tasksphere/features/auth/domain/entities/auth_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class AuthRepository {
  /// Login a user with email and password
  Future<Either<Failure, AuthEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> reAuthenticate({required String password});

  /// Register a new user
  Future<Either<Failure, AuthEntity>> register({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Failure, AuthEntity>> updateProfile({
    String? name,
    String? email,
    String? phone,
    XFile? img,
  });

  /// Logout the current user
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, AuthEntity>> loginWithGoogle();

  /// Check if a user is authenticated
  Future<Either<Failure, bool>> isAuthenticated();

  /// Get the current authenticated user
  Future<Either<Failure, AuthEntity>> getCurrentUser();
  Future<Either<Failure, void>> forgotPassword({required String email});
}
