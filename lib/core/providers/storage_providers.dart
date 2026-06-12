// Storage Providers
// Riverpod providers for storage-related services

import 'package:tasksphere/core/storage/local_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for SharedPreferences instance
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((
  ref,
) async {
  return await SharedPreferences.getInstance();
});

final localStorageServiceProvider = FutureProvider<LocalStorageService>((
  ref,
) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return LocalStorageService(prefs);
});
