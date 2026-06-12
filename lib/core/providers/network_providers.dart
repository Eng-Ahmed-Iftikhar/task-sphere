import 'package:tasksphere/core/constants/app_constants.dart';
import 'package:tasksphere/core/network/interceptors/auth_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../network/interceptors/retry_interceptor.dart';

part 'network_providers.g.dart';

@riverpod
Dio dio(Ref ref) {
  final dio = Dio();

  dio.options.baseUrl = AppConstants.apiBaseUrl;
  dio.options.connectTimeout = const Duration(milliseconds: 30000);
  dio.options.receiveTimeout = const Duration(milliseconds: 30000);
  dio.options.headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Add interceptors here if needed
  dio.interceptors.add(
    LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ),
  );
  dio.interceptors.add(RetryInterceptor(dio: dio));
  dio.interceptors.add(AuthInterceptor(ref));

  return dio;
}
