import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasksphere/core/constants/app_constants.dart';
import 'package:tasksphere/core/error/exceptions.dart';
import 'package:tasksphere/core/network/api_client.dart';
import 'package:tasksphere/core/providers/network_providers.dart';
import 'package:tasksphere/core/utils/app_utils.dart';
import 'package:tasksphere/features/auth/data/models/auth_model.dart';

abstract class AuthDataSource {
  /// Login a user with email and password
  Future<AuthModel> login({required String email, required String password});

  /// Register a new user
  Future<AuthModel> register({
    required String name,
    required String email,
    required String password,
  });

  Future<AuthModel> getCurrentUser();

  Future<AuthModel> updateProfile({String? name, String? email, XFile? img});

  Future<void> logout();
  Future<AuthModel> loginWithGoogle();
  Future<void> reAuthenticate({required String password});

  Future<void> forgotPassword({required String email});
}

class AuthDataSourceImpl implements AuthDataSource {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _firestore = FirebaseFirestore.instance.collection(
    'users',
  );
  final ApiClient _apiClient;

  AuthDataSourceImpl(this._apiClient);

  Future<String?> uploadImageToCloudinary(XFile imageFile) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
        'upload_preset': 'task_sphere_present',
      });

      final response = await _apiClient.post(
        'https://api.cloudinary.com/v1_1/dx30vfgsv/image/upload',
        data: formData,
      );

      return response.fold((failure) {
        print('Image upload failed: $failure');
        return null;
      }, (data) => data['secure_url'] as String?);
    } catch (e) {
      print('Upload failed: $e');
      return null;
    }
  }

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
      final provider = user.providerData.isNotEmpty
          ? user.providerData[0].providerId
          : 'password';
      final userDoc = await _firestore.doc(user.uid).get();
      if (!userDoc.exists) {
        await _firestore.doc(user.uid).set({
          'name': user.displayName ?? "no name",
          'email': user.email,
          'img_url': user.photoURL,
          'phone': user.phoneNumber,
          'provider': provider,
          'created_at': FieldValue.serverTimestamp(),
        });
      } else {
        await _firestore.doc(user.uid).update({
          'name': user.displayName ?? "no name",
          'email': user.email,
          'img_url': user.photoURL,
          'phone': user.phoneNumber,
          'provider': provider,
          'updated_at': FieldValue.serverTimestamp(),
        });
      }
      final accessToken = await user.getIdToken(true) as String;
      return AuthModel.fromJson({
        "access_token": accessToken,
        "provider": provider,
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
  Future<void> reAuthenticate({required String password}) async {
    try {
      // Check network connection
      final hasNetwork = await AppUtils.hasNetworkConnection();
      if (!hasNetwork) {
        throw NetworkException();
      }
      final currentUser = _auth.currentUser;

      final credential = EmailAuthProvider.credential(
        email: currentUser!.email!,
        password: password,
      );
      await currentUser.reauthenticateWithCredential(credential);
    } on Exception catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<AuthModel> updateProfile({
    String? name,
    String? email,
    XFile? img,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw UnauthorizedException(message: 'No authenticated user found');
      }

      final updates = <String, dynamic>{};

      if (name != null) {
        updates['name'] = name;
        await user.updateDisplayName(name);
      }
      if (email != null) {
        user.reload();
        await user.verifyBeforeUpdateEmail(email);
        updates['email'] = email;
      }

      if (img != null) {
        final imageUrl = await uploadImageToCloudinary(img);
        await user.updatePhotoURL(imageUrl);
        if (imageUrl != null) {
          updates['img_url'] = imageUrl;
        }
      }

      if (updates.isNotEmpty) {
        await _firestore.doc(user.uid).update(updates);
      }

      final accessToken = await user.getIdToken(true) as String;
      await user.reload();
      final provider = user.providerData.isNotEmpty
          ? user.providerData[0].providerId
          : 'password';

      return AuthModel.fromJson({
        "access_token": accessToken,
        "provider": provider,
        "user": {
          "name": updates['name'] ?? user.displayName ?? "no name",
          "email": updates['email'] ?? user.email ?? "",
          "img_url": updates['img_url'] ?? user.photoURL,
          "phone": updates['phone'] ?? user.phoneNumber,
          "provider": provider,
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
        "provider": user.providerData.isNotEmpty
            ? user.providerData[0].providerId
            : 'password',
        'created_at': FieldValue.serverTimestamp(),
      });
      final accessToken = await user.getIdToken(true) as String;
      final provider = user.providerData.isNotEmpty
          ? user.providerData[0].providerId
          : 'password';
      return AuthModel.fromJson({
        "access_token": accessToken,
        "provider": provider,
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
          'provider': user.providerData.isNotEmpty
              ? user.providerData[0].providerId
              : 'password',
          'created_at': FieldValue.serverTimestamp(),
        });
      }
      final accessToken = await user.getIdToken(true) as String;
      final provider = user.providerData.isNotEmpty
          ? user.providerData[0].providerId
          : 'password';
      return AuthModel.fromJson({
        "access_token": accessToken,
        "provider": provider,
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
      final provider = user.providerData.isNotEmpty
          ? user.providerData[0].providerId
          : 'password';

      if (!userDoc.exists) {
        await _firestore.doc(user.uid).set({
          'name': user.displayName ?? "no name",
          'email': user.email,
          'img_url': user.photoURL,
          'phone': user.phoneNumber,
          'provider': provider,
          'created_at': FieldValue.serverTimestamp(),
        });
      } else {
        await _firestore.doc(user.uid).update({
          'name': user.displayName ?? "no name",
          'email': user.email,
          'img_url': user.photoURL,
          'phone': user.phoneNumber,
          'provider': provider,
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
        "provider": provider,
      });
    } on Exception catch (e) {
      print("Google Sign-In error: $e");
      throw _handleException(e);
    }
  }
}

// Provider
final authRemoteDataSourceProvider = Provider<AuthDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);

  return AuthDataSourceImpl(apiClient);
});

// ApiClient provider
final apiClientProvider = Provider.autoDispose<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiClient(dio);
});
