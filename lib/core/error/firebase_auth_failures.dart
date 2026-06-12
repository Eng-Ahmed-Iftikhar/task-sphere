import 'package:tasksphere/core/error/failures.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Centralized Firebase Auth error codes
class FirebaseAuthCodes {
  static const userNotFound = 'user-not-found';
  static const invalidCredential = 'invalid-credential';
  static const wrongPassword = 'wrong-password';
  static const emailAlreadyInUse = 'email-already-in-use';
  static const invalidEmail = 'invalid-email';
  static const weakPassword = 'weak-password';
  static const userDisabled = 'user-disabled';
  static const tooManyRequests = 'too-many-requests';
  static const operationNotAllowed = 'operation-not-allowed';
}

class FirebaseAuthFailure extends Failure {
  final String code;

  const FirebaseAuthFailure({
    required super.message,
    required this.code,
    super.statusCode,
  });

  factory FirebaseAuthFailure.fromException(FirebaseAuthException e) {
    switch (e.code) {
      case FirebaseAuthCodes.userNotFound:
        return FirebaseAuthFailure(
          message: 'No user found with this email.',
          code: e.code,
        );

      case FirebaseAuthCodes.invalidCredential:
        return FirebaseAuthFailure(
          message:
              'The provided credentials are invalid or have expired. Please check your details and try again.',
          code: e.code,
        );

      case FirebaseAuthCodes.wrongPassword:
        return FirebaseAuthFailure(
          message: 'Incorrect password.',
          code: e.code,
        );

      case FirebaseAuthCodes.emailAlreadyInUse:
        return FirebaseAuthFailure(
          message: 'Email is already in use.',
          code: e.code,
        );

      case FirebaseAuthCodes.invalidEmail:
        return FirebaseAuthFailure(
          message: 'Invalid email address.',
          code: e.code,
        );

      case FirebaseAuthCodes.weakPassword:
        return FirebaseAuthFailure(
          message: 'Password is too weak.',
          code: e.code,
        );

      case FirebaseAuthCodes.userDisabled:
        return FirebaseAuthFailure(
          message: 'This account has been disabled.',
          code: e.code,
        );

      case FirebaseAuthCodes.tooManyRequests:
        return FirebaseAuthFailure(
          message: 'Too many attempts. Try again later.',
          code: e.code,
        );

      case FirebaseAuthCodes.operationNotAllowed:
        return FirebaseAuthFailure(
          message: 'Operation not allowed.',
          code: e.code,
        );

      default:
        return FirebaseAuthFailure(
          message: e.message ?? 'Authentication error occurred.',
          code: e.code,
        );
    }
  }

  @override
  List<Object?> get props => [message, statusCode, code];
}
