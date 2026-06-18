import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tasksphere/core/error/exceptions.dart';
import 'package:tasksphere/core/utils/app_utils.dart';
import 'package:tasksphere/features/todos/data/models/todo_model.dart';

abstract class TodoDataSource {
  /// Login a user with email and password
  Future<TodoModel> create({
    required String title,
    required String description,
  });

  /// Login a user with email and password
  Future<void> update({
    required String id,
    required String title,
    required String description,
  });

  /// Login a user with email and password
  Future<void> delete({required String id});
  Future<void> toggleCompleted({required String id, required bool completed});
  Future<List<TodoModel>> getAll();
  Future<TodoModel> getById({required String id});
}

class TodoDataSourceImpl implements TodoDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference userCollection = FirebaseFirestore.instance
      .collection('users');
  final CollectionReference todoCollection = FirebaseFirestore.instance
      .collection('todos');

  TodoDataSourceImpl();

  @override
  Future<TodoModel> create({
    required String title,
    required String description,
  }) async {
    try {
      // Check network connection
      final hasNetwork = await AppUtils.hasNetworkConnection();
      if (!hasNetwork) {
        throw NetworkException();
      }
      final user = _auth.currentUser;
      if (user == null) {
        throw UnauthorizedException(message: 'No authenticated user found');
      }

      final todoDoc = await todoCollection.add({
        'title': title,
        'description': description,
        'user': userCollection.doc(user.uid),
        'completed': false,
        'created_at': FieldValue.serverTimestamp(),
      });
      final todo = await todoCollection.doc(todoDoc.id).get();
      final data = todo.data() as Map<String, dynamic>;
      data["id"] = todoDoc.id;
      final userRef = data["user"] as DocumentReference;
      final userDoc = await userRef.get();
      final userData = userDoc.data() as Map<String, dynamic>;
      userData["id"] = userDoc.id;
      data["user"] = userData;
      return TodoModel.fromJson(data);
    } on Exception catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<void> update({
    required String id,
    required String title,
    required String description,
  }) async {
    try {
      // Check network connection
      final hasNetwork = await AppUtils.hasNetworkConnection();
      if (!hasNetwork) {
        throw NetworkException();
      }
      final user = _auth.currentUser;
      if (user == null) {
        throw UnauthorizedException(message: 'No authenticated user found');
      }

      await todoCollection.doc(id).update({
        'title': title,
        'description': description,
        'updated_at': FieldValue.serverTimestamp(),
      });
    } on Exception catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<void> toggleCompleted({
    required String id,
    required bool completed,
  }) async {
    try {
      // Check network connection
      final hasNetwork = await AppUtils.hasNetworkConnection();
      if (!hasNetwork) {
        throw NetworkException();
      }
      final user = _auth.currentUser;
      if (user == null) {
        throw UnauthorizedException(message: 'No authenticated user found');
      }

      await todoCollection.doc(id).update({
        'completed': completed,
        'updated_at': FieldValue.serverTimestamp(),
      });
    } on Exception catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<void> delete({required String id}) async {
    try {
      // Check network connection
      final hasNetwork = await AppUtils.hasNetworkConnection();
      if (!hasNetwork) {
        throw NetworkException();
      }
      final user = _auth.currentUser;
      if (user == null) {
        throw UnauthorizedException(message: 'No authenticated user found');
      }

      await todoCollection.doc(id).delete();
    } on Exception catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<TodoModel> getById({required String id}) async {
    try {
      // Check network connection
      final hasNetwork = await AppUtils.hasNetworkConnection();
      if (!hasNetwork) {
        throw NetworkException();
      }
      final user = _auth.currentUser;
      if (user == null) {
        throw UnauthorizedException(message: 'No authenticated user found');
      }

      final todo = await todoCollection.doc(id).get();
      final data = todo.data() as Map<String, dynamic>;
      data["id"] = todo.id;
      final userRef = data["user"] as DocumentReference;
      final userDoc = await userRef.get();
      final userData = userDoc.data() as Map<String, dynamic>;
      userData["id"] = userDoc.id;
      data["user"] = userData;
      return TodoModel.fromJson(data);
    } on Exception catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<List<TodoModel>> getAll() async {
    try {
      // Check network connection
      final hasNetwork = await AppUtils.hasNetworkConnection();
      if (!hasNetwork) {
        throw NetworkException();
      }
      final user = _auth.currentUser;
      if (user == null) {
        throw UnauthorizedException(message: 'No authenticated user found');
      }

      final todos = await todoCollection.get();
      final dataList = await Future.wait(
        todos.docs.map((todo) async {
          final data = todo.data() as Map<String, dynamic>;
          data["id"] = todo.id;
          final userRef = data["user"] as DocumentReference;
          final userDoc = await userRef.get();
          final userData = userDoc.data() as Map<String, dynamic>;
          userData["id"] = userDoc.id;
          data["user"] = userData;
          return TodoModel.fromJson(data);
        }),
      );
      return dataList;
    } on Exception catch (e) {
      throw _handleException(e);
    }
  }

  // Helper method to handle exceptions
  Exception _handleException(Exception e) {
    if (e is NetworkException ||
        e is ServerException ||
        e is UnauthorizedException ||
        e is FirebaseAuthException ||
        e is BadRequestException ||
        e is GoogleSignInException) {
      return e;
    }
    return ServerException(message: e.toString());
  }
}

// Provider
final todoDataSourceProvider = Provider<TodoDataSource>((ref) {
  return TodoDataSourceImpl();
});
