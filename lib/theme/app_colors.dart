import 'package:flutter/material.dart';

class AppColors {
  static const Color bgLight = Color(0xFFF5F5F7);       
  static const Color containerLight = Color(0xFFEEEEEE);
  static const Color surfaceLight = Colors.white;

  static const Color bgDark = Color(0xFF121212);
  static const Color containerDark = Color(0xFF1E1E1E);
  static const Color surfaceDark = Color(0xFF2D2D2D);
  static Color getContainerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? containerDark 
        : containerLight;
  }
}