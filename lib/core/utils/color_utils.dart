import 'package:flutter/material.dart';

Color parseColor(dynamic value) {
  if (value is String) {
    if (value.startsWith('#')) {
      return Color(int.parse(value.substring(1), radix: 16) + 0xFF000000);
    }
    // Handle named colors or other formats if needed
  }
  return const Color(0xFFB5BA8E);
}
