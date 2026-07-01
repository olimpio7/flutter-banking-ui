import 'package:flutter/material.dart';

class AppColors {
  static const Color bgLight = Color(0xFFF5F5F7);       
  static const Color containerLight = Color(0xFFEEEEEE);
  static const Color surfaceLight = Colors.white;

  static const Color bgDark = Color(0xFF18181B);
  static const Color containerDark = Color(0xFF27272A);
  static const Color surfaceDark = Color(0xFF3F3F46);
  static Color getContainerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? containerDark 
        : containerLight;
  }
}