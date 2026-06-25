import 'package:flutter/material.dart';

class AppColors {
  // --- PALETA CLARA (O seu padrão original)
  static const Color bgLight = Color(0xFFF5F5F7);       // Colors.grey[100]
  static const Color containerLight = Color(0xFFE0E0E0);  // Colors.grey[200]
  static const Color surfaceLight = Colors.white;

  // --- PALETA ESCURA AJUSTADA (Mais suave, menos agressiva)
  static const Color bgDark = Color(0xFF16161A);        // Preto fosco suave de fundo
  static const Color containerDark = Color(0xFF24242B);   // Cinza mais claro para os containers destacarem
  static const Color surfaceDark = Color(0xFF2C2C35);     // Sub-containers internos

  static Color getContainerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? containerDark 
        : containerLight;
  }
}