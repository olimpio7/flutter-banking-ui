import 'package:flutter/material.dart';

class AppColors {
  static const Color bgLight = Color(0xFFF5F5F7);       
  static const Color containerLight = Color(0xFFEEEEEE);
  static const Color surfaceLight = Colors.white;

  static const Color bgDark = Color(0xFF18181B); // Zinc 900 (Fundo Grafite Profundo)
  static const Color containerDark = Color(0xFF27272A); // Zinc 800 (Cards Grafite)
  static const Color surfaceDark = Color(0xFF3F3F46); // Zinc 700 (Bordas e detalhes)
  static Color getContainerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? containerDark 
        : containerLight;
  }
}