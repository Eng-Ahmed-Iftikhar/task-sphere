import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tasksphere/core/constants/app_constants.dart';
import 'package:tasksphere/core/error/exceptions.dart';
import 'package:tasksphere/core/utils/app_utils.dart';
import 'package:tasksphere/features/auth/data/models/auth_model.dart';

abstract class AuthRemoteDataSource {
  /// Login a user with email and password
  Future<AuthModel> login({required String email, required String password});

  /// Register a new user
  Future<AuthModel> register({
    required String name,
    required String email,
    required String password,
  });

  Future<AuthModel> getCurrentUser();
  Future<void> logout();
  Future<AuthModel> loginWithGoogle();

  Future<void> forgotPassword({required String email});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _firestore = FirebaseFirestore.instance.collection(
    'users',
  );

  AuthRemoteDataSourceImpl();

  @override
  Future<AuthModel> login({
    required String email,
    required String password,
  }) async {
    try {
      // Check network connection
      final hasNetwork = await AppUtils.hasNetworkConnection();
      if (!hasNetwork) {
        throw NetworkException();
      }

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;

      if (user == null) {
        throw ServerException(message: "Login failed");
      }

      final userDoc = await _firestore.doc(user.uid).get();
      if (!userDoc.exists) {
        await _firestore.doc(user.uid).set({
          'name': user.displayName ?? "no name",
          'email': user.email,
          'img_url': user.photoURL,
          'phone': user.phoneNumber,
          'created_at': FieldValue.serverTimestamp(),
        });
      } else {
        await _firestore.doc(user.uid).update({
          'name': user.displayName ?? "no name",
          'email': user.email,
          'img_url': user.photoURL,
          'phone': user.phoneNumber,
          'updated_at': FieldValue.serverTimestamp(),
        });
      }
      final accessToken = await user.getIdToken(true) as String;
      return AuthModel.fromJson({
        "access_token": accessToken,
        "user": {
          "name": user.displayName ?? "no name",
          "email": user.email ?? "",
          "img_url": user.photoURL,
          "phone": user.phoneNumber,
          "id": user.uid,
        },
      });
    } on Exception catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<AuthModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Check network connection
      final hasNetwork = await AppUtils.hasNetworkConnection();
      if (!hasNetwork) {
        throw NetworkException();
      }

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) {
        throw ServerException(message: "Registration failed");
      }
      await user.updateDisplayName(name);

      await _firestore.doc(user.uid).set({
        'name': name,
        'email': email,
        'img_url': user.photoURL,
        'phone': user.phoneNumber,
        'created_at': FieldValue.serverTimestamp(),
      });
      final accessToken = await user.getIdToken(true) as String;

      return AuthModel.fromJson({
        "access_token": accessToken,
        "user": {
          "name": user.displayName ?? "no name",
          "email": user.email ?? "",
          "img_url": user.photoURL,
          "phone": user.phoneNumber,
          "id": user.uid,
        },
      });
    } on Exception catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<AuthModel> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw UnauthorizedException(message: 'No authenticated user found');
      }

      final userDoc = await _firestore.doc(user.uid).get();
      if (!userDoc.exists) {
        _firestore.doc(user.uid).set({
          'name': user.displayName ?? "no name",
          'email': user.email,
          'img_url': user.photoURL,
          'phone': user.phoneNumber,
          'created_at': FieldValue.serverTimestamp(),
        });
      }
      final accessToken = await user.getIdToken(true) as String;

      return AuthModel.fromJson({
        "access_token": accessToken,
        "user": {
          "name": user.displayName ?? "no name",
          "email": user.email ?? "",
          "img_url": user.photoURL,
          "phone": user.phoneNumber,
          "id": user.uid,
        },
      });
    } on Exception catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      return _auth.signOut();
    } on Exception catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      return _auth.sendPasswordResetEmail(email: email);
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

  @override
  Future<AuthModel> loginWithGoogle() async {
    try {
      // Check network connection
      final hasNetwork = await AppUtils.hasNetworkConnection();
      if (!hasNetwork) {
        throw NetworkException();
      }

      await _googleSignIn.initialize(
        serverClientId: AppConstants.googleClientId,
      );
      // Trigger Google Sign-In
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      // Get auth details
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      final userCredential = await _auth.signInWithCredential(credential);

      final user = userCredential.user;

      if (user == null) {
        throw ServerException(message: "Google sign-in failed");
      }
      final userDoc = await _firestore.doc(user.uid).get();
      if (!userDoc.exists) {
        await _firestore.doc(user.uid).set({
          'name': user.displayName ?? "no name",
          'email': user.email,
          'img_url': user.photoURL,
          'phone': user.phoneNumber,
          'created_at': FieldValue.serverTimestamp(),
        });
      } else {
        await _firestore.doc(user.uid).update({
          'name': user.displayName ?? "no name",
          'email': user.email,
          'img_url': user.photoURL,
          'phone': user.phoneNumber,
          'updated_at': FieldValue.serverTimestamp(),
        });
      }
      final accessToken = await user.getIdToken(true) as String;

      return AuthModel.fromJson({
        "access_token": accessToken,
        "user": {
          "name": user.displayName ?? "no name",
          "email": user.email ?? "",
          "img_url": user.photoURL,
          "phone": user.phoneNumber,

          "id": user.uid,
        },
      });
    } on Exception catch (e) {
      print("Google Sign-In error: $e");
      throw _handleException(e);
    }
  }
}

// Provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl();
});
