import 'package:flutter/material.dart';

class AppColors {
  // --- MODO CLARO (O seu padrão original que você gosta)
  static const Color bgLight = Color(0xFFF5F5F7);       
  static const Color containerLight = Color(0xFFEEEEEE);  // Colors.grey[200]
  static const Color surfaceLight = Colors.white;

  // --- MODO ESCURO (Grafite Fosco Puro - Alto Contraste)
  static const Color bgDark = Color(0xFF121212);        // Preto fosco de fundo (padrão AMOLED)
  static const Color containerDark = Color(0xFF1E1E1E);   // Grafite suave para o SoftContainer destacar
  static const Color surfaceDark = Color(0xFF2D2D2D);     // Sub-containers internos

  static Color getContainerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? containerDark 
        : containerLight;
  }
}