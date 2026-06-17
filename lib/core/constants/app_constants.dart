import 'package:flutter/material.dart';

class AppConstants {
  static final primaryColor = Color(0xff667EEA);
  static final secondaryColor = Color(0xff764BA2);
  static const String todoStorageKey = "todos";
  static final RouteObserver<PageRoute<dynamic>> routeObserver =
      RouteObserver<PageRoute<dynamic>>();

  // Base URL for API calls
  static const String apiBaseUrl = "https://api.tasksphere.com";
  static const String offlineSyncBox = 'offlineSync';
  static const String googleClientId =
      "568613442085-8rrqjtvt6vs15bjra4ju12dd40srg925.apps.googleusercontent.com";
  static const String initialRoute = "/";
  static const String emailVerificationUrl =
      "https://tasksphere.com/email-verification";
}
