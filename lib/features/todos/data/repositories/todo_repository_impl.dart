import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tasksphere/core/error/exceptions.dart';
import 'package:tasksphere/core/error/failures.dart';
import 'package:tasksphere/core/error/firebase_auth_failures.dart';
import 'package:tasksphere/features/todos/data/datasources/todo_data_source.dart';
import 'package:tasksphere/features/todos/data/models/todo_model.dart';
import 'package:tasksphere/features/todos/domain/entities/todo_entity.dart';
import 'package:tasksphere/features/todos/domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoDataSource _dataSource;

  TodoRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, TodoEntity>> create({
    required String title,
    required String description,
  }) async {
    try {
      final response = await _dataSource.create(
        title: title,
        description: description,
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
  Future<Either<Failure, void>> update({
    required String id,
    required String title,
    required String description,
  }) async {
    try {
      final response = await _dataSource.update(
        id: id,
        title: title,
        description: description,
      );

      return Right(response);
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
  Future<Either<Failure, void>> toggleCompleted({
    required String id,
    required bool completed,
  }) async {
    try {
      final response = await _dataSource.toggleCompleted(
        id: id,
        completed: completed,
      );

      return Right(response);
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
  Future<Either<Failure, void>> completeAllTodos() async {
    try {
      final response = await _dataSource.toggleAllCompleted();

      return Right(response);
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
  Future<Either<Failure, TodoEntity>> getById({required String id}) async {
    try {
      final response = await _dataSource.getById(id: id);

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
  Future<Either<Failure, List<TodoEntity>>> getAll() async {
    try {
      final response = await _dataSource.getAll();

      return Right(response.map((e) => e.toEntity()).toList());
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
  Future<Either<Failure, void>> delete({required String id}) async {
    try {
      final response = await _dataSource.delete(id: id);

      return Right(response);
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
}

// Repository provider
final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  return TodoRepositoryImpl(ref.watch(todoDataSourceProvider));
});
