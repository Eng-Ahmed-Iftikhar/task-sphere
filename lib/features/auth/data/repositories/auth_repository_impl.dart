import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tasksphere/core/error/exceptions.dart';
import 'package:tasksphere/core/error/failures.dart';
import 'package:tasksphere/core/error/firebase_auth_failures.dart';
import 'package:tasksphere/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:tasksphere/features/auth/data/models/auth_model.dart';
import 'package:tasksphere/features/auth/domain/entities/auth_entity.dart';
import 'package:tasksphere/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, AuthEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.login(
        email: email,
        password: password,
      );

      return Right(response.toEntity());
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthFailure.fromException(e));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on Exception {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.register(
        name: name,
        email: email,
        password: password,
      );

      return Right(response.toEntity());
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthFailure.fromException(e));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on BadRequestException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } on Exception {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remoteDataSource.logout();
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthFailure.fromException(e));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on Exception {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      return Right(true);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthFailure.fromException(e));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on Exception {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      final user = await _remoteDataSource.getCurrentUser();
      return Right(user.toEntity());
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthFailure.fromException(e));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on Exception {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword({required String email}) async {
    try {
      await _remoteDataSource.forgotPassword(email: email);
      return Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthFailure.fromException(e));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on Exception {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> loginWithGoogle() async {
    try {
      final response = await _remoteDataSource.loginWithGoogle();
      return Right(response.toEntity());
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthFailure.fromException(e));
    } on GoogleSignInException catch (e) {
      return Left(
        FirebaseAuthFailure(
          code: e.code.toString(),
          message: e.description.toString(),
        ),
      );
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on Exception {
      return const Left(ServerFailure());
    }
  }
}

// Repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider));
});
