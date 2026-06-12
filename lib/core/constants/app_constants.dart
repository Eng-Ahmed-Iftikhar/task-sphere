import 'package:flutter/material.dart';

class AppConstants {
  static final primaryColor = Color(0xff667EEA);
  static final secondaryColor = Color(0xff764BA2);
  static const String todoStorageKey = "todos";
  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();

  // Base URL for API calls
  static const String apiBaseUrl = "https://api.tasksphere.com";
  static const String offlineSyncBox = 'offlineSync';
  static const String googleClientId =
      "61934947675-3r03d89mqpofi5no49fo2fijh2q325a6.apps.googleusercontent.com";
}
