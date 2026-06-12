// import 'package:tasksphere/features/auth/presentation/providers/auth_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthInterceptor extends Interceptor {
  final Ref ref;

  AuthInterceptor(this.ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // final authStore = ref.read(authProvider);
    // final authState = authStore.asData?.value;
    final authState = null;

    if (authState == null) {
      handler.next(options);
      return;
    }
    final accessToken = authState.accessToken;

    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }
}
